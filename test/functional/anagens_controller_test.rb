require 'test_helper'

class AnagensControllerTest < ActionController::TestCase
  setup do
    @anagen = anagens(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:anagens)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create anagen" do
    assert_difference('Anagen.count') do
      post :create, :anagen => { :codfis => @anagen.codfis, :codice => @anagen.codice, :cognome => @anagen.cognome, :nome => @anagen.nome, :pariva => @anagen.pariva, :ragsoc => @anagen.ragsoc, :tipo => @anagen.tipo }
    end

    assert_redirected_to anagen_path(assigns(:anagen))
  end

  test "should show anagen" do
    get :show, :id => @anagen
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @anagen
    assert_response :success
  end

  test "should update anagen" do
    put :update, :id => @anagen, :anagen => { :codfis => @anagen.codfis, :codice => @anagen.codice, :cognome => @anagen.cognome, :nome => @anagen.nome, :pariva => @anagen.pariva, :ragsoc => @anagen.ragsoc, :tipo => @anagen.tipo }
    assert_redirected_to anagen_path(assigns(:anagen))
  end

  test "should destroy anagen" do
    assert_difference('Anagen.count', -1) do
      delete :destroy, :id => @anagen
    end

    assert_redirected_to anagens_path
  end
end
