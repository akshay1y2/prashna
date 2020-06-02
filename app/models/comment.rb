# == Schema Information
#
# Table name: comments
#
#  id               :bigint           not null, primary key
#  content          :text             default(""), not null
#  user_id          :bigint           not null
#  commentable_type :string
#  commentable_id   :bigint
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  net_upvotes      :integer          default(0), not null
#  marked_abuse     :boolean          default(FALSE)
#
class Comment < ApplicationRecord
  include VotableFeatures
  
  belongs_to :user
  belongs_to :commentable, polymorphic: true, counter_cache: true
  has_many :votes, as: :votable, dependent: :restrict_with_error
  has_many :spams, as: :spammable
  has_many :credit_transactions, as: :creditable

  validates :content_words, length: {
    minimum: ENV['minimum_content_length'].to_i,
    message: I18n.t('question.errors.content_length')
  }

  before_create :check_if_question_is_published, if: -> { self.commentable.is_a? Question }

  default_scope { where marked_abuse: false }

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
