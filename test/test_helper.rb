ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

class ActionDispatch::IntegrationTest
  def json_response
    JSON.parse(response.body)
  end

  def auth_headers_for(user)
    { 'Authorization': user.token }
  end

  def assert_equal_datetime(key, datetime_with_zone)
    json_datetime = DateTime.parse json_response[key]
    datetime = datetime_with_zone.to_datetime
    assert_equal json_datetime.to_i, datetime.to_i
  end
end
