require 'test_helper'

class TesdocsControllerTest < ActionController::TestCase
  setup do
    @tesdoc = tesdocs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tesdocs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tesdoc" do
    assert_difference('Tesdoc.count') do
      post :create, :tesdoc => { :data_doc => @tesdoc.data_doc, :descriz => @tesdoc.descriz, :num_doc => @tesdoc.num_doc, :tipo_doc => @tesdoc.tipo_doc }
    end

    assert_redirected_to tesdoc_path(assigns(:tesdoc))
  end

  test "should show tesdoc" do
    get :show, :id => @tesdoc
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @tesdoc
    assert_response :success
  end

  test "should update tesdoc" do
    put :update, :id => @tesdoc, :tesdoc => { :data_doc => @tesdoc.data_doc, :descriz => @tesdoc.descriz, :num_doc => @tesdoc.num_doc, :tipo_doc => @tesdoc.tipo_doc }
    assert_redirected_to tesdoc_path(assigns(:tesdoc))
  end

  test "should destroy tesdoc" do
    assert_difference('Tesdoc.count', -1) do
      delete :destroy, :id => @tesdoc
    end

    assert_redirected_to tesdocs_path
  end
end
