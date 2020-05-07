class Answer < ApplicationRecord
  include BasicPresenter::Concern

  belongs_to :user
  belongs_to :question
  has_many :votes, as: :votable, dependent: :destroy

  validates :content_words, length: {
    minimum: ENV['minimum_content_length'].to_i,
    message: I18n.t('answer.errors.content_length') 
  }

  private def content_words
    content.split(' ')
  end
end
