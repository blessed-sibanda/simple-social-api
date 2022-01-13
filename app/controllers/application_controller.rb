class ApplicationController < ActionController::API
  include JwtAuth

  protected

  def render_error_message(message, status = :unauthorized)
    render json: { error: message }, status: status
  end
end
