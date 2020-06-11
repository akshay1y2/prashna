require 'test_helper'

class QuestionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    user = FactoryBot.create(:user, :first_user)
    @question = FactoryBot.create(:question, user: user)
    sign_in_as user
  end

  test "should get index" do
    get questions_url
    assert_response :success
  end

  test "should get new" do
    @question.user.update(credits: 1) if @question.user.credits < 1
    get new_question_url
    assert_response :success
  end

  test "should create question" do
    @question.user.update(credits: 1) if @question.user.credits < 1
    assert_difference('Question.count') do
      post questions_url, params: { question: { topics: '', title: 'new title', content: 'content', publish: 0 } }
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
end
