# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Printatnd::Application.initialize!

# Pass everything through CAS
if Rails.env.development? or true
  CASClient::Frameworks::Rails::Filter.configure(
    :cas_base_url => "https://login-test.cc.nd.edu/cas",
    :validate_url => "https://login-test.cc.nd.edu/cas/serviceValidate",
    :force_ssl_verification => true
  )
else
  CASClient::Frameworks::Rails::Filter.configure(
    :cas_base_url => "https://login.nd.edu/cas",
    :validate_url => "https://login.nd.edu/cas/serviceValidate",
    :force_ssl_verification => true
  )
end

