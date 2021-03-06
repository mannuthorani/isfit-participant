require 'test_helper'

class QuestionsControllerTest < ActionController::TestCase
  setup do
    @question = questions(:one)
  end

  test "should get index" do
    get :index
    assert_response 302 #:success
    #assert_not_nil assigns(:questions)
  end

  test "should get new" do
    get :new
    assert_response 302 #:success
  end

  test "should show question" do
    get :show, :id => @question.to_param
    assert_response 302 #:success
  end

  test "should get edit" do
    get :edit, :id => @question.to_param
    assert_response 302 #:success
  end
end
