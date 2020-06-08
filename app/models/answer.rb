# == Schema Information
#
# Table name: answers
#
#  id             :bigint           not null, primary key
#  content        :text             default(""), not null
#  question_id    :bigint           not null
#  user_id        :bigint           not null
#  comments_count :integer          default(0), not null
#  net_upvotes    :integer          default(0), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  marked_abuse   :boolean          default(FALSE)
#
class Answer < ApplicationRecord
  include BasicPresenter::Concern
  include VotableFeatures

  validates :content_words, length: {
    minimum: ENV['minimum_content_length'].to_i,
    message: I18n.t('answer.errors.content_length')
  }

  belongs_to :user
  belongs_to :question, counter_cache: true
  has_many :votes, as: :votable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :credit_transactions, as: :creditable
  has_many :spams, as: :spammable, dependent: :destroy

  before_create :check_if_question_is_published
  after_commit :send_email_to_questioner, on: [:create]

  default_scope { where marked_abuse: false }

  def update_answerer_credits!
    ct_sum = credit_transactions.where(user: user, reason: 'voted').sum(:credits)
    if net_upvotes >= ENV['net_upvotes_for_answer'].to_i && ct_sum < ENV['credits_for_answer'].to_i
      credit_transactions.create!(user: user, credits: ENV['credits_for_answer'].to_i, reason: 'voted')
    elsif net_upvotes < ENV['net_upvotes_for_answer'].to_i && ct_sum >= ENV['credits_for_answer'].to_i
      credit_transactions.create!(user: user, credits: -1 * ENV['credits_for_answer'].to_i, reason: 'voted')
    end
  end

  def published?
    question.published?
  end

  private def send_email_to_questioner
    AnswerMailer.delay.new_answer_posted(id)
  end

  private def check_if_question_is_published
    unless published?
      errors.add(:base, 'Question must be published')
      throw :abort
    end
  end
end
