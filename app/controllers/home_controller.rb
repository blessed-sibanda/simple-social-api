class HomeController < ApplicationController
  def index
    render_error_message "welcome", :ok
  end
end
