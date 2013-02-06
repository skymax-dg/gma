require 'test_helper'

class ConfsControllerTest < ActionController::TestCase
  setup do
    @conf = confs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:confs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create conf" do
    assert_difference('Conf.count') do
      post :create, conf: { coderigdoc: @conf.coderigdoc, codice: @conf.codice, defaspetto: @conf.defaspetto, defbanca: @conf.defbanca, defcaustra: @conf.defcaustra, defcorriere: @conf.defcorriere, defdtrit: @conf.defdtrit, defnote: @conf.defnote, defnrcolli: @conf.defnrcolli, deforarit: @conf.deforarit, defpagam: @conf.defpagam, defporto: @conf.defporto, defum: @conf.defum, defvalore: @conf.defvalore, insana: @conf.insana, insart: @conf.insart, insind: @conf.insind }
    end

    assert_redirected_to conf_path(assigns(:conf))
  end

  test "should show conf" do
    get :show, id: @conf
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @conf
    assert_response :success
  end

  test "should update conf" do
    put :update, id: @conf, conf: { coderigdoc: @conf.coderigdoc, codice: @conf.codice, defaspetto: @conf.defaspetto, defbanca: @conf.defbanca, defcaustra: @conf.defcaustra, defcorriere: @conf.defcorriere, defdtrit: @conf.defdtrit, defnote: @conf.defnote, defnrcolli: @conf.defnrcolli, deforarit: @conf.deforarit, defpagam: @conf.defpagam, defporto: @conf.defporto, defum: @conf.defum, defvalore: @conf.defvalore, insana: @conf.insana, insart: @conf.insart, insind: @conf.insind }
    assert_redirected_to conf_path(assigns(:conf))
  end

  test "should destroy conf" do
    assert_difference('Conf.count', -1) do
      delete :destroy, id: @conf
    end

    assert_redirected_to confs_path
  end
end
