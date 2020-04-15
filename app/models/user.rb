class User < ApplicationRecord
  validates :name, presence: true
  validates :email, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  #FIXME_AB: add uniqueness validation for the reset password token
  #FIXME_AB: also add index on token
  has_secure_password

  before_create :set_verification_token, unless: :admin
  after_commit :send_verification_token, unless: :admin, on: [:create]

  def activate(token)
    if token == confirm_token
      self.active = true
      self.confirm_token = nil
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
    (reset_token == token) && (reset_sent_at > 2.hours.ago)
  end

  private
    def set_verification_token
      #FIXME_AB: confirm_token should also have uniqueess validation
      self.confirm_token = SecureRandom.urlsafe_base64
    end

    def send_verification_token
      UserMailer.with(id: id).verification.deliver_later
    end
end
