require 'test_helper'

class AnaindsControllerTest < ActionController::TestCase
  setup do
    @anaind = anainds(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:anainds)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create anaind" do
    assert_difference('Anaind.count') do
      post :create, :anaind => { :cap => @anaind.cap, :indir => @anaind.indir, :localita => @anaind.localita, :nrmag => @anaind.nrmag, :tpind => @anaind.tpind }
    end

    assert_redirected_to anaind_path(assigns(:anaind))
  end

  test "should show anaind" do
    get :show, :id => @anaind
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @anaind
    assert_response :success
  end

  test "should update anaind" do
    put :update, :id => @anaind, :anaind => { :cap => @anaind.cap, :indir => @anaind.indir, :localita => @anaind.localita, :nrmag => @anaind.nrmag, :tpind => @anaind.tpind }
    assert_redirected_to anaind_path(assigns(:anaind))
  end

  test "should destroy anaind" do
    assert_difference('Anaind.count', -1) do
      delete :destroy, :id => @anaind
    end

    assert_redirected_to anainds_path
  end
end
