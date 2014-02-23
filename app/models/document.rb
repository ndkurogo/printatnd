class Document < ActiveRecord::Base
  belongs_to :print
  attr_accessor :tempfile

  def fetch
    policy = $filepicker.policy('read')
    signature = $filepicker.sign(policy)
    response = Excon.get(self.url, query: {policy: policy, signature: signature})

    self.filename = response.headers["X-File-Name"] || "Untitled"

    self.tempfile = Tempfile.new(self.filename, encoding: 'ascii-8bit')
    self.tempfile.write(response.body)
    self.tempfile.close

    save!
  end

  def needs_conversion?
    DIRECT_EXTENSIONS.none? do |extension|
      self.filename.downcase.end_with?(extension)
    end
  end
  
  def convert
    policy = $filepicker.policy('read')
    signature = $filepicker.sign(policy)
    actual_url = "#{self.url}?policy=#{policy}&signature=#{signature}"
    
    response = Excon.get("https://docs.google.com/viewer", :query => {:url => actual_url})
    gp_url = response.body[/gpUrl:('[^']*')/,1]
    
    if status = gp_url.present?
      pdf_url = ExecJS.eval(gp_url)
      cookie_jar = Tempfile.new("cookie_jar")

      command = ["curl", "-s", "-L", "-c", cookie_jar.path, "-o", self.tempfile.path, pdf_url]

      begin
        IO.popen(command) do |f|
          logger.info command.join(" ")
          logger.info f.gets
        end
      ensure
        cookie_jar.close!
      end
    end

    return status
  end
  
  def enqueue
    options = {
      "Collate" => "True"
    }

    options.merge!("sides" => "two-sided-long-edge") if print.double_sided

    # Image-specific options
    if IMAGE_EXTENSIONS.include? File.extname(self.filename).downcase
      image = Magick::Image::read(self.tempfile.path).first

      # No less than 96ppi, no greater than one page
      dimensions = [image.rows, image.columns]
      if [dimensions.max/10.0, dimensions.min/7.5].max < 96
        options.merge!("ppi" => "96")
      else
        options.merge!("fit-to-page" => false)
      end
    end

    options_array = options.map { |k,v| v ? ["-o", "#{k}=#{v}"] : ["-o", "#{k}"] }.flatten

    command = ["lp", "-c", "-E", "-t", self.filename.to_s.shellescape, "-d", print.color ? "ND-Pharos-All-Color" : "ND-Pharos-All-BW", "-U", print.netid.to_s.shellescape, "-n", print.copies.to_s.shellescape].concat(options_array) << "--" << self.tempfile.path.shellescape

    IO.popen(command.join(" ")) do |f|
      logger.info command.join(" ")
      logger.info f.gets
    end
  end
  
  def announce
    if Rails.env.production?
      #json = ActiveSupport::JSON.encode({})
      #Pusher["printatnd"].trigger("print", json)
    end
  end

  def cleanup
    self.tempfile.unlink

    policy = $filepicker.policy('remove')
    signature = $filepicker.sign(policy)
    Excon.delete(self.url, query: {policy: policy, signature: signature})
  end
end
