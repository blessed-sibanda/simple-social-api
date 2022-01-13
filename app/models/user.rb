class User < ApplicationRecord
  before_validation { email&.downcase! }

  has_secure_password

  validates :name, :email, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?

  def token
    payload = { id: id }
    JWT.encode payload, Rails.application.credentials[:secret_key_base]
  end

  private

  def password_required?
    password_digest.blank? || !password.blank?
  end
end
