class User < ApplicationRecord
  #FIXME_AB:  active boolean
  #FIXME_AB: admin boolean
  enum state: { inactive: false, active: true }
  enum role:  { user: false, admin: true }

  validates :name, presence: true
  validates :email, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  has_secure_password

  before_create :set_token, if: :user?
  #FIXME_AB: should be after_comit on create or after_create_commit
  after_create :send_token, if: :user?

  def activate(token)
    if active?
      "User: #{name} is already active!"
    elsif token == confirm_token
      self.state = 'active'
      self.confirm_token = nil
      #FIXME_AB: what if save fails
      save
      "User: #{name} is activated!"
    else
      "Incorrect Token!"
    end
  end

  def send_reset_link
    update(reset_token: SecureRandom.urlsafe_base64, reset_sent_at: Time.current)
    UserMailer.with(id: id).reset_password.deliver_later
  end

  private
    #FIXME_AB: rename to set_verification_token
    def set_token
      self.confirm_token = SecureRandom.urlsafe_base64
    end

    #FIXME_AB: send_verification_token
    def send_token
      UserMailer.with(id: id).verification.deliver_later
    end
end
