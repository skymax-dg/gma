require 'test_helper'

class MagsControllerTest < ActionController::TestCase
  setup do
    @mag = mags(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:mags)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create mag" do
    assert_difference('Mag.count') do
      post :create, :mag => { :codice => @mag.codice, :descriz => @mag.descriz }
    end

    assert_redirected_to mag_path(assigns(:mag))
  end

  test "should show mag" do
    get :show, :id => @mag
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @mag
    assert_response :success
  end

  test "should update mag" do
    put :update, :id => @mag, :mag => { :codice => @mag.codice, :descriz => @mag.descriz }
    assert_redirected_to mag_path(assigns(:mag))
  end

  test "should destroy mag" do
    assert_difference('Mag.count', -1) do
      delete :destroy, :id => @mag
    end

    assert_redirected_to mags_path
  end
end
