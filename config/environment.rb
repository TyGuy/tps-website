# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
TpsWebsite::Application.initialize!

ActionMailer::Base.delivery_method = :smtp

ActionMailer::Base.smtp_settings = {
   :address => "smtp.gmail.com",
   :port => 587,
   :domain => "google.com",
   :authentication => 'plain',
   :user_name => "phoenix.scholars.it@gmail.com",
   :password => "",
   :enable_starttls_auto => true
}
