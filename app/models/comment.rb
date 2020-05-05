class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  has_many :votes, as: :votable, dependent: :restrict_with_error

  validates :content, presence: true
  #FIXME_AB: lets add another validation to have x words in comments. x is taken from env.

  #FIXME_AB: we should have a before create check that comment is allowed on published questions only
end
