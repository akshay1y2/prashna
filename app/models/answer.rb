class Answer < ApplicationRecord
  include BasicPresenter::Concern
  include VotableFeatures

  belongs_to :user
  belongs_to :question
  has_many :votes, as: :votable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  validates :content_words, length: {
    minimum: ENV['minimum_content_length'].to_i,
    message: I18n.t('answer.errors.content_length') 
  }

  before_create :check_if_question_is_published
  after_commit :send_email_to_questioner, on: [:create]

  private def content_words
    content.split(' ')
  end

  private def send_email_to_questioner
    AnswerMailer.with(id: id).new_answer_posted.deliver_later
  end

  private def check_if_question_is_published
    unless question.published?
      errors.add(:base, 'Question must be published')
      throw :abort
    end
  end
end
