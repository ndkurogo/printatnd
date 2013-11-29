# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Printatnd::Application.initialize!

# Pass everything through CAS
CASClient::Frameworks::Rails::Filter.configure(
  :cas_base_url => "https://login-test.cc.nd.edu/cas",
  :validate_url => "https://login-test.cc.nd.edu/cas/serviceValidate",
  :force_ssl_verification => true
)

