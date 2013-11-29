class ApplicationController < ActionController::Base
  before_filter CASClient::Frameworks::Rails::Filter
  before_filter :set_globals

  def set_globals
    gon.printers = $printers
    gon.status = $redis.hgetall("status")
  end
end

