class Question < ApplicationRecord
  attr_accessor :new_publish
  paginates_per 2

  belongs_to :user
  has_one_attached :attachment
  has_and_belongs_to_many :topics
  has_many :credit_transactions, as: :creditable
  has_many :notifications, as: :notifiable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :restrict_with_error
  has_many :votes, as: :votable, dependent: :restrict_with_error

  validates :title, presence: true, uniqueness: { case_sensitive: false }

  with_options if: :published? do
    validates :content, presence: true
    validates :content_words, length: {
      minimum: ENV['minimum_content_length'].to_i,
      message: I18n.t('question.errors.content_length')
    }
    validates :topics, length: {
      minimum: 1,
      message: I18n.t('question.errors.topics_absent')
    }
  end

  with_options if: :new_publish do
    before_validation :set_published_at
    after_commit :notify_users, on: [:create, :update]
  end

  before_create :check_if_user_has_credits
  before_update :check_if_question_is_updatable
  after_create_commit :deduct_credit_of_user
  after_destroy_commit :add_credit_back_to_user

  scope :all_published, -> { where.not(published_at: nil) }
  scope :all_unpublished, -> { where(published_at: nil) }
  scope :by_title, ->(title = nil) { where("lower(title) like ?", "%#{title.downcase}%") }

  def to_param
    "#{id}-#{title.parameterize}"
  end

  def published?
    published_at.present?
  end

  def set_published_at
    self.published_at = Time.current
  end

  def set_topics(topic_names)
    self.topics = Topic.get_topics_by_names(topic_names)
  end

  def topic_names
    topics.pluck('name')
  end

  def posted_by?(user_obj)
    user == user_obj
  end

  private def content_words
    content.split(' ')
  end

  private def check_if_user_has_credits
    #FIXME_AB: don't hardcode 1. take from env
    if user.credits < 1
      errors.add(:base, I18n.t('question.errors.not_enough_credits'))
      throw :abort
    end
  end

  private def check_if_question_is_updatable
    if votes.count > 0 || answers_count > 0 || comments_count > 0
      errors.add(:base, I18n.t('question.errors.not_updatable'))
      throw :abort
    end
  end

  private def deduct_credit_of_user
    unless user.credit_transactions.create(
        credits: -1 * ENV['ask_question_credit'].to_i,
        reason: 'question asked',
        creditable: self
      )
      raise 'something went wrong, error code [:credit-deduction-failed]'
    end
  end

  private def add_credit_back_to_user
    unless user.credit_transactions.create(
        credits: ENV['ask_question_credit'].to_i,
        reason: 'deleted question asked',
        creditable: self
      )
      raise 'something went wrong, error code [:credit-addition-failed]'
    end
  end

  private def notify_users
    topics.joins(:topics_users).distinct.pluck('topics_users.user_id').each do |id|
      Notification.create(user_id: id, message: '.new_question', notifiable: self)
    end
    # ActionCable.server.broadcast('questions', json: {
    #   topics: topic_names,
    #   head: I18n.t('notification.new_question_head'),
    #   body: title + I18n.t('notification.new_question_body'),
    #   time: Time.current.strftime("%-d/%-m/%y: %H:%M %Z")
    # })
  end
end
