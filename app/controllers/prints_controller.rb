class PrintsController < ApplicationController
  before_filter :cas_auth
  before_filter :cache_new, :only => :new
  before_filter :sanitize_input, :only => :create

  def index
    redirect_to root_path
  end

  def new
    @print = Print.new
  end

  def create
    @print = Print.new(params[:print])
    @print.ip = get_ip

    @print.build_documents(params[:urls], params[:ga_client_id])

    respond_to do |format|
      if success = @print.save
        @print.enqueue

        set_flash(@print)
        set_cookies(@print)

        format.html { redirect_to root_path(success: success) }
      else
        format.html { render action: "new" }
      end
    end
  end

  protected

  def cas_auth
    if !cookies.signed[:cas_authed] or cookies[:netid].blank?
      CASClient::Frameworks::Rails::Filter.filter(self)

      cookies.signed[:cas_authed] = {
        :value => true,
        :expires => 1.month.from_now
      }

      cookies[:netid] = {
        :value => session[:cas_user],
        :expires => 1.month.from_now
      }
    end
  end

  private

  def sanitize_input
    params[:urls] = if params[:urls].blank?
      []
    else
      params[:urls].split(",").reject(&:blank?)
    end    

    params[:print] ||= {}
    params[:print][:copies] = 1 if params[:print][:copies].blank?
  end

  def get_ip
    request.headers["X-Real-IP"] if Rails.env.production?
  end

  def set_flash(print)
    flash[:netid]    = print.netid
    flash[:printer]  = print.color ? "All Color" : "All BW"
    flash[:count]    = print.documents.size
  end

  def set_cookies(print)
    secure = Rails.env.production?
    domain = if Rails.env.production?
      request.host
    end

    cookies[:netid] = {value: print.netid, secure: secure, domain: domain}
  end
  
  def cache_new
    unless params[:success]
      expires_in 5.minutes, :public => true
    end
  end
end

