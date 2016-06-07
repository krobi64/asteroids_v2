# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Mpc::Application.initialize!

# Access to our wordpress database
#WpPost.establish_connection "wordpress"