require 'test_helper'

class CausmagsControllerTest < ActionController::TestCase
  setup do
    @causmag = causmags(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:causmags)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create causmag" do
    assert_difference('Causmag.count') do
      post :create, :causmag => { :descriz => @causmag.descriz, :fattura => @causmag.fattura, :tipo => @causmag.tipo }
    end

    assert_redirected_to causmag_path(assigns(:causmag))
  end

  test "should show causmag" do
    get :show, :id => @causmag
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @causmag
    assert_response :success
  end

  test "should update causmag" do
    put :update, :id => @causmag, :causmag => { :descriz => @causmag.descriz, :fattura => @causmag.fattura, :tipo => @causmag.tipo }
    assert_redirected_to causmag_path(assigns(:causmag))
  end

  test "should destroy causmag" do
    assert_difference('Causmag.count', -1) do
      delete :destroy, :id => @causmag
    end

    assert_redirected_to causmags_path
  end
end
