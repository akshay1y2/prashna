class Question < ApplicationRecord
  include BasicPresenter::Concern
  include VotableFeatures
  attr_accessor :new_publish
  paginates_per 6

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

  belongs_to :user
  has_one_attached :attachment
  has_and_belongs_to_many :topics
  has_many :credit_transactions, as: :creditable
  has_many :notifications, as: :notifiable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :restrict_with_error
  has_many :votes, as: :votable, dependent: :restrict_with_error
  has_many :answers, dependent: :restrict_with_error

  with_options if: :new_publish do
    before_validation :set_published_at
    after_commit :notify_users, on: [:create, :update]
  end
  before_create :check_if_user_has_credits
  before_update :check_if_question_is_updatable
  before_save :attachment_mime_type
  after_create_commit :deduct_credit_of_user
  after_destroy_commit :add_credit_back_to_user

  scope :all_published, -> { where.not(published_at: nil) }
  scope :all_unpublished, -> { where(published_at: nil) }
  scope :by_title, ->(title = nil) { where("lower(title) like ?", "%#{title.downcase}%") }
  #FIXME_AB: make class method
  scope :search_for_ids, ->(term = '') { find_by_sql ["SELECT id FROM questions WHERE title LIKE :term
      UNION SELECT id FROM questions WHERE id IN(SELECT questions_topics.question_id
            FROM topics JOIN questions_topics ON questions_topics.topic_id = topics.id
            WHERE topics.name LIKE :term)", { term: "%#{term.downcase}%" }]
  }

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
    self.topics = Topic.get_topics_by_names(topic_names) unless published?
  end

  def topic_names
    topics.pluck(:name)
  end

  def posted_by?(user_obj)
    user == user_obj
  end

  private def check_if_user_has_credits
    if user.credits < ENV['ask_question_credit'].to_i
      errors.add(:base, I18n.t('question.errors.not_enough_credits'))
      throw :abort
    end
  end

  private def check_if_question_is_updatable
    if votes.count.positive? || answers_count.positive? || comments_count.positive?
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
    users_to_notfy = topics.joins(:topics_users).distinct.pluck('topics_users.user_id') - [user.id]
    users_to_notfy.each { |id| notifications.create(user_id: id, message: '.new_question') }
  end

  private def attachment_mime_type
    if attachment.attached? && !(attachment.content_type == 'application/pdf' || attachment.image?)
      errors.add(:attachment, I18n.t('question.errors.invalid_file'))
      throw :abort
    end
  end
end
