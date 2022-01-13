class AuthController < ApplicationController
  before_action :authenticate_user!, only: [:profile]

  def login
    user = User.find_by_email params[:email]
    if user&.authenticate_password params[:password]
      render json: { access_token: user.token }, status: :created
    else
      render json: { error: "Invalid email/password" }, status: :unauthorized
    end
  end

  def profile
    @user = current_user
    render "users/show"
  end
end
