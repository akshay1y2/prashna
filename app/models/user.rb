class User < ApplicationRecord
  paginates_per 5

  has_secure_password
  has_one_attached :avatar
  has_many :credit_transactions, dependent: :restrict_with_error
  has_and_belongs_to_many :topics
  has_many :questions, dependent: :restrict_with_error
  has_many :notifications, dependent: :destroy
  has_many :votes, dependent: :restrict_with_error
  has_many :comments, dependent: :restrict_with_error
  has_many :answers, dependent: :restrict_with_error
  has_many :payment_transactions, dependent: :restrict_with_error

  validates :name, presence: true
  validates :email, uniqueness: { case_sensitive: false }, format: { with: /\A[\w\d][^@\s]*@[\w\d-]+(\.?[\w]+)*\z/ }
  validates :reset_token, :confirm_token, uniqueness: { case_sensitive: false }, allow_nil: true
  validates :new_notifications_count, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :password, format: { 
    with: /\A(?=.{6,})(?=.*[a-zA-Z])(?=.*\d)(?=.*[[:^alnum:]])/x,
    message: I18n.t('user.errors.password_format') 
  }, if: :password

  with_options unless: :active?, absence: { message: I18n.t('user.errors.inactive_update') } do
    validates :avatar
    validates :topics
  end

  before_create :set_verification_token, unless: :admin
  after_commit :send_verification_token, unless: :admin, on: [:create]

  def activate(token)
    if token == confirm_token
      self.active = true
      self.confirm_token = nil
      build_credits_and_payment_transaction(PurchasePack.default.find_by_name('Sign-Up-Pack'))
      save
    else
      false
    end
  end

  def send_reset_link
    update(reset_token: SecureRandom.urlsafe_base64, reset_sent_at: Time.current)
    UserMailer.with(id: id).reset_password.deliver_later
  end

  def verify_password_reset_token(token)
    (reset_token == token) &&
      (reset_sent_at > ENV['reset_token_valid_hours'].to_i.hours.ago)
  end

  def set_topics(topic_names)
    self.topics = Topic.get_topics_by_names(topic_names)
  end

  def topic_names
    topics.pluck(:name)
  end

  def refresh_new_notification_count!
    update_columns(new_notifications_count: notifications.new_notifications.count)
  end

  def build_credits_and_payment_transaction(pack)
    payment_transactions.build(
      credits: pack.credits,
      amount: pack.current_price,
      payable: pack
    )
    credit_transactions.build(
      credits: pack.credits,
      reason: pack.name,
      creditable: pack
    )
  end

  private
    def set_verification_token
      self.confirm_token = SecureRandom.urlsafe_base64
    end

    def send_verification_token
      UserMailer.with(id: id).verification.deliver_later
    end
end
