require 'test_helper'

class ContosControllerTest < ActionController::TestCase
  setup do
    @conto = contos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:contos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create conto" do
    assert_difference('Conto.count') do
      post :create, :conto => { :annoese => @conto.annoese, :azienda => @conto.azienda, :cntrpartita => @conto.cntrpartita, :codice => @conto.codice, :descriz => @conto.descriz, :tipoconto => @conto.tipoconto }
    end

    assert_redirected_to conto_path(assigns(:conto))
  end

  test "should show conto" do
    get :show, :id => @conto
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @conto
    assert_response :success
  end

  test "should update conto" do
    put :update, :id => @conto, :conto => { :annoese => @conto.annoese, :azienda => @conto.azienda, :cntrpartita => @conto.cntrpartita, :codice => @conto.codice, :descriz => @conto.descriz, :tipoconto => @conto.tipoconto }
    assert_redirected_to conto_path(assigns(:conto))
  end

  test "should destroy conto" do
    assert_difference('Conto.count', -1) do
      delete :destroy, :id => @conto
    end

    assert_redirected_to contos_path
  end
end
