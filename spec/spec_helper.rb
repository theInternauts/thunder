ENV['RACK_ENV'] ||= 'test'
# If we set the RACK_ENV environment variable to test it sets the sinatra
# application environment to test as well, so it will raise errors if our code
# is broken instead of just saying "Internal Server Error"

require './thunder_app'

require 'shoulda-matchers'
require 'faker'

require 'spec/helpers/factory_helper'

require 'capybara/rspec'
# Capybara allows us to test web applications easily. Let's load the library!

# See https://github.com/jnicklas/capybara#using-capybara-with-rspec
# For more details


Capybara.app = Sinatra::Application
# Capybara needs to know which application to test.
# By setting the app attribute to Sinatra::Application
# We're telling Capybara to test the application in thunder_app.rb

# See https://github.com/jnicklas/capybara#setup
# For more details on what Capybara.app does

# Sinatra::Application is a class represents the application you're building.
# This is using what's known as sinatra `classic` style.


# See http://www.sinatrarb.com/intro.html#Modular%20vs.%20Classic%20Style
# For comparison of classic vs modular sinatra styles

ActiveRecord::Base.logger = Logger.new('/dev/null')

RSpec.configure do |config|
  config.before do
    User.destroy_all
    Talk.destroy_all
  end

  config.include FactoryHelper

end

def login(user)
  if user.respond_to? :email
    attributes = { email: user[:email], password: 'password' }
    user = attributes
  end
  visit '/'
  click_on "log-in-link"

  fill_in :user_email, with: user[:email]
  fill_in :user_password, with: user[:password]

  click_on "log-in-button"
end
