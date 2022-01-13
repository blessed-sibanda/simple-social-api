class User < ApplicationRecord
  before_validation { email&.downcase! }

  has_secure_password

  validates :name, :email, :password, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
  validates :password, length: { minimum: 6 }

  def token
    payload = { id: id }
    JWT.encode payload, Rails.application.credentials[:secret_key_base]
  end
end
