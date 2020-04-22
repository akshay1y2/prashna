class User < ApplicationRecord
  has_secure_password
  has_one_attached :avatar
  has_many :credit_transactions, dependent: :restrict_with_error
  has_and_belongs_to_many :topics
  has_many :questions, dependent: :restrict_with_error
  has_many :notifications, dependent: :destroy

  validates :name, presence: true
  validates :email, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :reset_token, :confirm_token, uniqueness: { case_sensitive: false }, allow_nil: true

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
      credit_transactions.build(credits: ENV['signup_credits'], reason: 'signup')
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
    self.topics = Topic.by_names(topic_names.split(",").map(&:strip).reject(&:empty?))
  end

  def topic_names
    topics.pluck('name')
  end

  private
    def set_verification_token
      self.confirm_token = SecureRandom.urlsafe_base64
    end

    def send_verification_token
      UserMailer.with(id: id).verification.deliver_later
    end
end
