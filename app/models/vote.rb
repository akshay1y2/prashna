class Vote < ApplicationRecord
  #FIXME_AB: hash
  enum vote_type: [:up, :down]
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :vote_type, presence: true

  #FIXME_AB: we need to sure that user should have only one entry per votable

  #FIXME_AB: remove limit.
  #FIXME_AB: split this scope :by_user(user), by_votable(votable)
  scope :by_user_on_votable, ->(user_obj, votable_obj) { where(user: user_obj, votable: votable_obj).limit(1) }

  #FIXME_AB: :up_votes, remove votable
  scope :up_count_of_votable, ->(obj) { where(vote_type: :up, votable: obj).count }
  #FIXME_AB: same as above
  scope :down_count_of_votable, ->(obj) { where(vote_type: :down, votable: obj).count }

  after_commit :set_net_upvotes_of_votable

  private def set_net_upvotes_of_votable
    #FIXME_AB: votable.refresh_votes!
    votable.update_columns(net_upvotes: Vote.up_count_of_votable(votable) - Vote.down_count_of_votable(votable))
  end
end
