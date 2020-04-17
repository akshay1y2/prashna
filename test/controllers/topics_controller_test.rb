require 'test_helper'

class TopicsControllerTest < ActionDispatch::IntegrationTest
  test "should get search" do
    get topics_search_url
    assert_response :success
  end

end
