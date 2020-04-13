class User < ApplicationRecord
  enum state: { inactive: false, active: true }
  enum role:  { user: false, admin: true }

  validates :name, presence: true
  validates :email, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  has_secure_password

  before_create :set_token, if: :user?
  after_create :send_token, if: :user?

  def activate(token)
    if active?
      "User: #{name} is already active!"
    elsif token == confirm_token
      self.state = 'active'
      self.confirm_token = nil
      save
      "User: #{name} is activated!"
    else
      "Incorrect Token!"
    end
  end

  private
    def set_token
      self.confirm_token = SecureRandom.urlsafe_base64
    end

    def send_token
      UserMailer.with(id: id).verification.deliver_later
    end
end
