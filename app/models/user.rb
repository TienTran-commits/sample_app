class User < ApplicationRecord
  attr_accessor :remember_token

  # Em chay "framgia-ci run --local" thi no bao khong duoc de dau cach o day a
  before_save{email.downcase!}
  validates :name, presence: true,
                   length: {maximum: Settings.validation.name_max_digits}
  validates :email, presence: true,
                    length: {maximum: Settings.validation.email_max_digits},
                    format: {with: Settings.regex.email},
                    uniqueness: true
  validates :password, presence: true,
                      length: {minimum: Settings.validation.password_min_digits}
  has_secure_password

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
  def authenticated? remember_token
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end
end
