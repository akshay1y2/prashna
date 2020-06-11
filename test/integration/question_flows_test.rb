require 'test_helper'

class QuestionFlowsTest < ActionDispatch::IntegrationTest
  setup do
    user = FactoryBot.create(:user, :first_user)
    @question = FactoryBot.create(:question, user: user)
    sign_in_as user
  end

  test 'should spam question of other users' do
    @question.update(content: '| '*10, published_at: Time.current)
    post spams_url, params: { spam: { reason: 'test' }, spammable: "question-#{@question.id}", commit: 'Submit' }, xhr: true
    assert_equal '{"status":false,"message":"You can not spam your own content."}', @response.body
    sign_in_as FactoryBot.create(:user, :second_user)
    post spams_url, params: { spam: { reason: 'test' }, spammable: "question-#{@question.id}" }, xhr: true
    assert_equal '{"status":true,"message":"Reported as spam!"}', @response.body
  end

  test 'should publish created question' do
    get  drafts_questions_url
    assert_select "h5.card-header a", @question.title
    patch question_url(@question), params: { question: { topics: 'rails', title: @question.title, content: '| '*10, publish: 1 } }
    assert_equal 'Question was successfully updated.', flash[:notice]
    assert_redirected_to question_url(@question)
  end

  test 'should not post question without login' do
    delete logout_url
    post questions_url, params: { question: { topics: '', title: 'new title', content: 'content', publish: 0 } }
    assert_equal 'Please log-in first.', flash[:notice]
    assert_redirected_to login_url
  end

  test "should unauthorize other users" do
    sign_in_as FactoryBot.create(:user, :second_user)
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
