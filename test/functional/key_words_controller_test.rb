require 'test_helper'

class KeyWordsControllerTest < ActionController::TestCase
  setup do
    @key_word = key_words(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:key_words)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create key_word" do
    assert_difference('KeyWord.count') do
      post :create, key_word: {  }
    end

    assert_redirected_to key_word_path(assigns(:key_word))
  end

  test "should show key_word" do
    get :show, id: @key_word
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @key_word
    assert_response :success
  end

  test "should update key_word" do
    put :update, id: @key_word, key_word: {  }
    assert_redirected_to key_word_path(assigns(:key_word))
  end

  test "should destroy key_word" do
    assert_difference('KeyWord.count', -1) do
      delete :destroy, id: @key_word
    end

    assert_redirected_to key_words_path
  end
end
