# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
NTTG3::Application.initialize!
Dir.glob( File.dirname(__FILE__) + "lib/locales/*.{rb,yml}" ) 
