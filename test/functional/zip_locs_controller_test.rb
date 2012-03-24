require 'test_helper'

class ZipLocsControllerTest < ActionController::TestCase
  setup do
    @zip_loc = zip_locs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:zip_locs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create zip_loc" do
    assert_difference('ZipLoc.count') do
      post :create, zip_loc: @zip_loc.attributes
    end

    assert_redirected_to zip_loc_path(assigns(:zip_loc))
  end

  test "should show zip_loc" do
    get :show, id: @zip_loc
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @zip_loc
    assert_response :success
  end

  test "should update zip_loc" do
    put :update, id: @zip_loc, zip_loc: @zip_loc.attributes
    assert_redirected_to zip_loc_path(assigns(:zip_loc))
  end

  test "should destroy zip_loc" do
    assert_difference('ZipLoc.count', -1) do
      delete :destroy, id: @zip_loc
    end

    assert_redirected_to zip_locs_path
  end
end
