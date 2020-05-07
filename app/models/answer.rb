class Answer < ApplicationRecord
  include BasicPresenter::Concern

  belongs_to :user
  belongs_to :question
  has_many :votes, as: :votable, dependent: :destroy

  validates :content_words, length: {
    minimum: ENV['minimum_content_length'].to_i,
    message: I18n.t('answer.errors.content_length') 
  }

  after_commit :send_email_to_questioner, on: [:create]

  private def content_words
    content.split(' ')
  end

  private def send_email_to_questioner
    AnswerMailer.with(id: id).new_answer_posted.deliver_later
  end
end
