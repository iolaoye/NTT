require 'test_helper'

class FemControllerTest < ActionController::TestCase
  test "should get fem_tables" do
    get :fem_tables
    assert_response :success
  end

end
