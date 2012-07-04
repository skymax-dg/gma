require 'test_helper'

class PaesesControllerTest < ActionController::TestCase
  setup do
    @paese = paeses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:paeses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create paese" do
    assert_difference('Paese.count') do
      post :create, :paese => { :descriz => @paese.descriz, :tpeu => @paese.tpeu }
    end

    assert_redirected_to paese_path(assigns(:paese))
  end

  test "should show paese" do
    get :show, :id => @paese
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @paese
    assert_response :success
  end

  test "should update paese" do
    put :update, :id => @paese, :paese => { :descriz => @paese.descriz, :tpeu => @paese.tpeu }
    assert_redirected_to paese_path(assigns(:paese))
  end

  test "should destroy paese" do
    assert_difference('Paese.count', -1) do
      delete :destroy, :id => @paese
    end

    assert_redirected_to paeses_path
  end
end
