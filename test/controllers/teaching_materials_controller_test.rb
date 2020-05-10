require 'test_helper'

class TeachingMaterialsControllerTest < ActionDispatch::IntegrationTest
  test "should get crate" do
    get teaching_materials_crate_url
    assert_response :success
  end

  test "should get destroy" do
    get teaching_materials_destroy_url
    assert_response :success
  end

end
