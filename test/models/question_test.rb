# == Schema Information
#
# Table name: questions
#
#  id             :bigint           not null, primary key
#  title          :string           default(""), not null
#  content        :text             default(""), not null
#  user_id        :bigint           not null
#  published_at   :datetime
#  comments_count :bigint           default(0), not null
#  answers_count  :bigint           default(0), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  net_upvotes    :integer          default(0), not null
#  marked_abuse   :boolean          default(FALSE)
#
require 'test_helper'

class QuestionTest < ActiveSupport::TestCase
  def setup
    @user = FactoryBot.create :user
    @question = FactoryBot.build :question, user: @user
  end

  test 'should create draft' do
    @question.title = 'title'
    assert_difference ['Question.unpublished.count', '@user.credit_transactions.count'], 1 do
      assert @question.save
    end
  end

  test 'should not create question' do
    @question.title = ''
    assert_no_difference ['Question.count', '@user.credit_transactions.count'] do
      assert_not @question.save
    end

    assert_not_nil @question.errors[:title]
  end

  test 'should publish question' do
    @question.new_publish = true
    @question.title = 'title'
    @question.content = '| '*10
    assert_difference 'Question.published.count', 1 do
      assert @question.save
    end
  end

  test 'should not publish question' do
    @question.new_publish = true
    assert_no_difference 'Question.published.count' do
      assert_not @question.save
    end
    assert_includes @question.errors.keys, :content_words
  end

  test 'should update question' do
    @question.save
    assert @question.update(content: '| '*10, published_at: Time.current)
  end

  test 'should not update question' do
    @question.save
    assert_not @question.update(content: '| '*10, comments_count: 1)
    assert_includes @question.errors[:base], "This question contains a response. Hence, not updatable."
  end

  test 'should destroy question' do
    @question.save
    assert_difference 'Question.count' => -1, '@user.credit_transactions.count' => 1 do
      @question.destroy
    end
  end
end
