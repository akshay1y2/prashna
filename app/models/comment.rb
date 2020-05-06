class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  has_many :votes, as: :votable, dependent: :restrict_with_error

  validates :content_words, length: {
    minimum: ENV['minimum_content_length'].to_i,
    message: I18n.t('question.errors.content_length')
  }

  before_create :check_if_question_is_published, if: -> { self.commentable.is_a? Question }

  private def content_words
    content.split(' ')
  end

  def check_if_question_is_published
    unless commentable.published?
      errors.add(:base, 'Question must be published')
      throw :abort
    end
  end
end
