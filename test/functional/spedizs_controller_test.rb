require 'test_helper'

class SpedizsControllerTest < ActionController::TestCase
  setup do
    @spediz = spedizs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:spedizs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create spediz" do
    assert_difference('Spediz.count') do
      post :create, :spediz => { :aspetto => @spediz.aspetto, :caustras => @spediz.caustras, :corriere => @spediz.corriere, :dest1 => @spediz.dest1, :dest2 => @spediz.dest2, :dtrit => @spediz.dtrit, :nrcolli => @spediz.nrcolli, :orarit => @spediz.orarit, :peso => @spediz.peso, :porto => @spediz.porto, :tesdoc_id => @spediz.tesdoc_id }
    end

    assert_redirected_to spediz_path(assigns(:spediz))
  end

  test "should show spediz" do
    get :show, :id => @spediz
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @spediz
    assert_response :success
  end

  test "should update spediz" do
    put :update, :id => @spediz, :spediz => { :aspetto => @spediz.aspetto, :caustras => @spediz.caustras, :corriere => @spediz.corriere, :dest1 => @spediz.dest1, :dest2 => @spediz.dest2, :dtrit => @spediz.dtrit, :nrcolli => @spediz.nrcolli, :orarit => @spediz.orarit, :peso => @spediz.peso, :porto => @spediz.porto, :tesdoc_id => @spediz.tesdoc_id }
    assert_redirected_to spediz_path(assigns(:spediz))
  end

  test "should destroy spediz" do
    assert_difference('Spediz.count', -1) do
      delete :destroy, :id => @spediz
    end

    assert_redirected_to spedizs_path
  end
end
