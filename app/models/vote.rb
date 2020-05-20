class Vote < ApplicationRecord
  enum vote_type: { up: 0, down: 1 }
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :vote_type, presence: true

  scope :by_user,    ->(user_obj)    { where user: user_obj }
  scope :on_votable, ->(votable_obj) { where votable: votable_obj }
  scope :up_votes,   -> { where vote_type: :up }
  scope :down_votes, -> { where vote_type: :down }

  before_create :check_if_entry_is_duplicated, :check_if_voting_own_content, :check_if_question_is_published
  after_commit :update_answerer_credits, if: -> { self.votable.is_a? Answer }
  after_commit :set_net_upvotes_of_votable

  private def check_if_entry_is_duplicated
    unless self.class.by_user(user).on_votable(votable).count.zero?
      errors.add(:base, I18n.t('vote.errors.vote_present'))
      throw :abort
    end
  end

  private def check_if_voting_own_content
    if user == votable.user
      errors.add(:base, I18n.t('vote.errors.voting_own_content'))
      throw :abort
    end
  end

  private def check_if_question_is_published
    unless votable.published?
      errors.add(:base, I18n.t('vote.errors.not_published'))
      throw :abort
    end
  end

  private def set_net_upvotes_of_votable
    votable.refresh_votes!
  end

  private def update_answerer_credits
    votable.update_answerer_credits!
  end
end
