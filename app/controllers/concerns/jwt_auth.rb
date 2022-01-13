module JwtAuth
  protected

  def verify_jwt
    auth_header = request.headers["authorization"]

    if auth_header
      begin
        token = auth_header.split("Bearer ").last
        payload = JWT.decode token, Rails.application.credentials[:secret_key_base]
        @current_user = User.find payload.first["id"]
        return { user: @current_user }
      rescue JWT::ExpiredSignature
        return { error: "expired token" }
      rescue JWT::DecodeError
        return { error: "invalid token" }
      rescue ActiveRecord::RecordNotFound
        return { error: "user not found" }
      end
    else
      return { error: "authentication header missing" }
    end
  end
end
