class Comment < ApplicationRecord
  include VotableFeatures
  
  belongs_to :user
  belongs_to :commentable, polymorphic: true, counter_cache: true
  has_many :votes, as: :votable, dependent: :restrict_with_error

  validates :content_words, length: {
    minimum: ENV['minimum_content_length'].to_i,
    message: I18n.t('question.errors.content_length')
  }

  before_create :check_if_question_is_published, if: -> { self.commentable.is_a? Question }

  def published?
    commentable.published?
  end

  def check_if_question_is_published
    unless published?
      errors.add(:base, 'Question must be published')
      throw :abort
    end
  end
end
