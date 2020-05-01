class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  has_many :votes, as: :votable, dependent: :restrict_with_error

  validates :content, presence: true
end
