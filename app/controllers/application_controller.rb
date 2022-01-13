class ApplicationController < ActionController::API
  protected

  def authenticate_user!
    auth_header = request.headers["authorization"]

    if auth_header
    else
      render_error_message ''
    end
  end

  def render_error_message(message, status = :unauthorized)
    render json: { error: message }, status: status
  end
end
