# == Schema Information
#
# Table name: users
#
#  id                      :bigint           not null, primary key
#  name                    :string
#  email                   :string
#  password_digest         :string
#  admin                   :boolean          default(FALSE), not null
#  credits                 :integer          default(0), not null
#  active                  :boolean          default(FALSE), not null
#  confirm_token           :string
#  reset_token             :string
#  reset_sent_at           :datetime
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  new_notifications_count :integer          default(0), not null
#  stripe_token            :string
#  auth_token              :string
#
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
  has_many :spams, dependent: :restrict_with_error

  validates :name, presence: true
  validates :auth_token, uniqueness: true, allow_nil: false, if: :active?
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
    validates :auth_token
  end

  before_create :set_verification_token, unless: :admin
  after_commit :send_verification_token, unless: :admin, on: [:create]

  scope :active, -> { where active: true }
  scope :without_auth_token, -> { where auth_token: nil }

  def activate(token)
    if token == confirm_token
      self.active = true
      self.confirm_token = nil
      set_auth_token
      assign_signup_credits
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

  def set_auth_token
    self.auth_token = SecureRandom.urlsafe_base64
  end

  def topic_names
    topics.pluck(:name)
  end

  def spammed?(spammable)
    spams.for_spammable(spammable).present?
  end

  def refresh_new_notification_count!
    update_columns(new_notifications_count: notifications.new_notifications.count)
  end

  def create_pending_payment_transaction(pack)
    payment_transactions.pending.create(
      credits: pack.credits,
      amount: pack.current_price,
      purchase_pack: pack
    )
  end

  def create_credit_transaction(pack)
    credit_transactions.create(
      credits: pack.credits,
      reason: pack.name,
      creditable: pack
    )
  end

  def create_refund_credit_transaction(pack, reason ='Asked for refund.')
    credit_transactions.create(
      credits: -1 * pack.credits,
      reason: reason,
      creditable: pack
    )
  end

  def ensure_stripe_customer_exists
    logger.tagged("payment_transaction: customer") do
      unless stripe_token?
        customer_data = {
          email: email,
          name: Rails.env + ' - ' + name,
          address: {city: '', country: '', line1: '', line2: "", postal_code: '', state: ''}
        }
        logger.info("creating new customer with data: #{customer_data}")
        customer = Stripe::Customer.create(customer_data)
        update(stripe_token: customer.id)
      end
    end
  end

  private
    def set_verification_token
      self.confirm_token = SecureRandom.urlsafe_base64
    end

    def send_verification_token
      UserMailer.with(id: id).verification.deliver_later
    end

    def assign_signup_credits
      pack = PurchasePack.default.find_by_name('Sign-Up-Pack')
      payment_transactions.paid.create(
        credits: pack.credits,
        amount: pack.current_price,
        purchase_pack: pack
      )
      create_credit_transaction(pack)
    end
end
