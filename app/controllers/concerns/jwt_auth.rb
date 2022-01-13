module JwtAuth
  protected

  def authenticate_user!
    auth_header = request.headers["authorization"]

    if auth_header
      token = auth_header.split("Bearer ").last
      payload = JWT.decode token, Rails.application.credentials[:secret_key_base]
      @current_user = User.find payload.first["id"]
    else
      render_error_message "authentication header missing"
    end
  end

  def current_user
    @current_user
  end
end
