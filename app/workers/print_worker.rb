class PrintWorker
  @queue = :printing

  def self.perform(document_id)
    document = Document.find(document_id)
    document.fetch

    submit_ga_event(document.ga_cid)
    
    ok = document.needs_conversion? ? document.convert : true

    if ok
      document.enqueue
      document.announce
    end

    document.cleanup
  end

  def self.submit_ga_event(cid)
    Excon.post("https://www.google-analytics.com/collect",
      :headers => { "Content-Type" => "application/x-www-form-urlencoded" },
      :body => URI.encode_www_form(:v => 1, :tid => "UA-10196293-53", :cid => cid, :t => "event", :ec => "print", :ea => "submitted"))
  end

end
