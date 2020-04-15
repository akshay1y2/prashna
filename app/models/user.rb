class User < ApplicationRecord
  has_secure_password
  has_one_attached :avatar

  validates :name, presence: true
  validates :email, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :reset_token, :confirm_token, uniqueness: { case_sensitive: false }, allow_nil: true
  validates :avatar, absence: { message: I18n.t('user.errors.inactive_image_update') }, unless: :active?

  before_create :set_verification_token, unless: :admin
  after_commit :send_verification_token, unless: :admin, on: [:create]

  def activate(token)
    if token == confirm_token
      self.active = true
      self.confirm_token = nil
      self.credits = 5
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

  private
    def set_verification_token
      self.confirm_token = SecureRandom.urlsafe_base64
    end

    def send_verification_token
      UserMailer.with(id: id).verification.deliver_later
    end
end
