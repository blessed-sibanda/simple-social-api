class User < ApplicationRecord
  before_validation { email&.downcase! }

  has_secure_password
  has_one_attached :avatar

  validates :name, :email, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?

  def token(exp = 1.day.to_i)
    payload = { id: id, exp: Time.now.to_i + exp }
    JWT.encode payload, Rails.application.credentials[:secret_key_base]
  end

  private

  def password_required?
    password_digest.blank? || !password.blank?
  end
end
