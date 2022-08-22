class User < ApplicationRecord
  before_save {email.downcase!}
  validates :name, presence: true,
                   length: {maximum: Settings.validation.name_max_digits}
  validates :email, presence: true,
                    length: {maximum: Settings.validation.email_max_digits},
                    format: {with: Settings.regex.email},
                    uniqueness: true
  validates :password, presence: true,
                      length: {minimum: Settings.validation.password_min_digits}
  has_secure_password

  # Return the hash digest of the given string
  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create(string, cost)
    end
  end
end