class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token

  before_save{email.downcase!}
  before_create :create_activation_digest
  validates :name, presence: true,
                   length: {maximum: Settings.validation.name_max_digits}
  validates :email, presence: true,
                    length: {maximum: Settings.validation.email_max_digits},
                    format: {with: Settings.regex.email},
                    uniqueness: true
  validates :password, presence: true,
                      length: {minimum: Settings.validation.password_min_digits}
  has_secure_password

  scope :activated_accounts, ->{where(activated: true)}

  # Return the hash digest of the given string.
  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create(string, cost:)
    end

    # Returns a random token.
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  # Remembers a user in the db for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated? attribute, token
    digest = send("#{attribute}_digest")
    return false unless digest

    BCrypt::Password.new(digest).is_password?(token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Activates an account
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # Send activation email
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  private

  # Creates and assigns the activation token and digest
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
