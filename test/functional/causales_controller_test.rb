require 'test_helper'

class CausalesControllerTest < ActionController::TestCase
  setup do
    @causale = causales(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:causales)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create causale" do
    assert_difference('Causale.count') do
      post :create, :causale => { :azienda => @causale.azienda, :contoiva => @causale.contoiva, :descriz => @causale.descriz, :tipoiva => @causale.tipoiva, :tiporeg => @causale.tiporeg }
    end

    assert_redirected_to causale_path(assigns(:causale))
  end

  test "should show causale" do
    get :show, :id => @causale
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @causale
    assert_response :success
  end

  test "should update causale" do
    put :update, :id => @causale, :causale => { :azienda => @causale.azienda, :contoiva => @causale.contoiva, :descriz => @causale.descriz, :tipoiva => @causale.tipoiva, :tiporeg => @causale.tiporeg }
    assert_redirected_to causale_path(assigns(:causale))
  end

  test "should destroy causale" do
    assert_difference('Causale.count', -1) do
      delete :destroy, :id => @causale
    end

    assert_redirected_to causales_path
  end
end
