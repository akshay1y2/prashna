require 'test_helper'

class QuestionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @question = questions(:one)
    sign_in_as :one
  end

  test "should get index" do
    get questions_url
    assert_response :success
  end

  test "should get new" do
    get new_question_url
    assert_response :success
  end

  test "should create question" do
    assert_difference('Question.count') do
      post questions_url, params: { question: { topics: '', title: 'Title', content: 'content', publish: 0 } }
    end

    assert_redirected_to question_url(Question.last)
  end

  test "should show question" do
    get question_url(@question)
    assert_response :success
  end

  test "should get edit" do
    get edit_question_url(@question)
    assert_response :success
  end

  test "should update question" do
    patch question_url(@question), params: { question: { topics: 'rails', title: @question.title, content: 'content', publish: 0 } }
    assert_equal 'Question was successfully updated.', flash[:notice]
    assert_redirected_to question_url(@question)
  end

  test "should destroy question" do
    assert_difference('Question.count', -1) do
      delete question_url(@question)
    end

    assert_equal 'Question was successfully destroyed.', flash[:notice]
    assert_redirected_to questions_url
  end

  test "should get drafts" do
    get drafts_questions_url
    assert_response :success
  end

  test "should unauthorize other users" do
    sign_in_as :two
    get edit_question_url(@question)
    assert_redirected_to root_url
    assert_equal 'Access Denied!', flash[:notice]
    patch question_url(@question)
    assert_redirected_to root_url
    assert_equal 'Access Denied!', flash[:notice]
    delete question_url(@question)
    assert_redirected_to root_url
    assert_equal 'Access Denied!', flash[:notice]
  end
end
