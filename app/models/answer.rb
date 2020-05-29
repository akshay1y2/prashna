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
  has_many :spams, as: :spammable

  before_create :check_if_question_is_published
  after_commit :send_email_to_questioner, on: [:create]

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
    AnswerMailer.with(id: id).new_answer_posted.deliver_later
  end

  private def check_if_question_is_published
    unless published?
      errors.add(:base, 'Question must be published')
      throw :abort
    end
  end
end
