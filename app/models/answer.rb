class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question

  validates :content, presence: true
  validates :content_words, length: {
    minimum: ENV['minimum_content_length'].to_i,
    message: I18n.t('answer.errors.content_length') 
  }

  private def content_words
    content.split(' ')
  end
end
