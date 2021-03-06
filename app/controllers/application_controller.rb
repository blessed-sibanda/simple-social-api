class ApplicationController < ActionController::API
  protected

  def authenticate_user!
    auth = verify_jwt
    render_error_message auth[:error] unless auth[:user]
    @current_user = auth[:user]
  end

  def render_error_message(message, status = :unauthorized)
    render json: { error: message }, status: status
  end

  def current_user
    @current_user
  end

  private

  include JwtAuth
end
