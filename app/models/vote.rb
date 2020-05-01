class Vote < ApplicationRecord
  enum vote_type: [:up, :down]
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :vote_type, presence: true

  scope :by_user_on_votable, ->(user_obj, votable_obj) { where(user: user_obj, votable: votable_obj).limit(1) }
  scope :up_count_of_votable, ->(obj) { where(vote_type: :up, votable: obj).count }
  scope :down_count_of_votable, ->(obj) { where(vote_type: :down, votable: obj).count }

  after_commit :set_net_upvotes_of_votable

  private def set_net_upvotes_of_votable
    votable.update_columns(net_upvotes: Vote.up_count_of_votable(votable) - Vote.down_count_of_votable(votable))
  end
end
