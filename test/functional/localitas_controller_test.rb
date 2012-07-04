require 'test_helper'

class LocalitasControllerTest < ActionController::TestCase
  setup do
    @localita = localitas(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:localitas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create localita" do
    assert_difference('Localita.count') do
      post :create, :localita => { :cap => @localita.cap, :codfis => @localita.codfis, :descriz => @localita.descriz, :prov => @localita.prov }
    end

    assert_redirected_to localita_path(assigns(:localita))
  end

  test "should show localita" do
    get :show, :id => @localita
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @localita
    assert_response :success
  end

  test "should update localita" do
    put :update, :id => @localita, :localita => { :cap => @localita.cap, :codfis => @localita.codfis, :descriz => @localita.descriz, :prov => @localita.prov }
    assert_redirected_to localita_path(assigns(:localita))
  end

  test "should destroy localita" do
    assert_difference('Localita.count', -1) do
      delete :destroy, :id => @localita
    end

    assert_redirected_to localitas_path
  end
end
