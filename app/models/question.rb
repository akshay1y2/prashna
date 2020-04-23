class Question < ApplicationRecord
  belongs_to :user
  has_one_attached :attachment
  has_and_belongs_to_many :topics

  validates :title, presence: true, uniqueness: { case_sensitive: false }

  with_options if: :published? do
    validates :content, presence: true
    validates :topics, length: { minimum: 1, message: I18n.t('question.errors.topics_absent') }
  end

  before_create :check_if_user_has_credits
  before_update :check_if_question_is_updatable
  after_create_commit :deduct_credit_of_user
  after_destroy_commit :add_credit_back_to_user

  scope :all_published, -> { where.not(published_at: nil) }

  def to_param
    "#{id}-#{title.parameterize}"
  end

  def published?
    published_at.present?
  end

  def set_topics(topic_names)
    self.topics = Topic.by_names(topic_names.split(",").map(&:strip).reject(&:empty?))
  end

  def topic_names
    topics.pluck('name')
  end

  #FIXME_AB: we should also have a before action in questions controller to check when user tries to create question(new & create actions)
  private def check_if_user_has_credits
    if user.credits < 1
      errors.add(:base, I18n.t('question.errors.not_enough_credits'))
      throw :abort
    end
  end

  private def check_if_question_is_updatable
    if vote_count > 0 || answers_count > 0 || comments_count > 0
      errors.add(:base, I18n.t('question.errors.not_updatable'))
      throw :abort
    end
  end

  private def deduct_credit_of_user
    #FIXME_AB: polymorphic columns are not being populated
    user.credit_transactions.create(
      credits: -1 * ENV['ask_question_credit'].to_i,
      reason: 'question asked'
    )
    #FIXME_AB: you should also check if transaction was created successfully or not, else raise error 'something went wrong, error code [:credit-deduction-failed]'
  end

  private def add_credit_back_to_user
    #FIXME_AB: same comments as deduct_credit_of_user
    user.credit_transactions.create(
      credits: ENV['ask_question_credit'].to_i,
      reason: 'deleted question asked'
    )
  end
end
