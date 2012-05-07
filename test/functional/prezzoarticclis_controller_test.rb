require 'test_helper'

class PrezzoarticclisControllerTest < ActionController::TestCase
  setup do
    @prezzoarticcli = prezzoarticclis(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:prezzoarticclis)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create prezzoarticcli" do
    assert_difference('Prezzoarticcli.count') do
      post :create, :prezzoarticcli => { :prezzo => @prezzoarticcli.prezzo }
    end

    assert_redirected_to prezzoarticcli_path(assigns(:prezzoarticcli))
  end

  test "should show prezzoarticcli" do
    get :show, :id => @prezzoarticcli
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @prezzoarticcli
    assert_response :success
  end

  test "should update prezzoarticcli" do
    put :update, :id => @prezzoarticcli, :prezzoarticcli => { :prezzo => @prezzoarticcli.prezzo }
    assert_redirected_to prezzoarticcli_path(assigns(:prezzoarticcli))
  end

  test "should destroy prezzoarticcli" do
    assert_difference('Prezzoarticcli.count', -1) do
      delete :destroy, :id => @prezzoarticcli
    end

    assert_redirected_to prezzoarticclis_path
  end
end
