class ApplicationController < ActionController::Base
  protect_from_forgery
  include SimpleCaptcha::ControllerHelpers

  private
  def check_logged_in
    if not user_signed_in?
      redirect_to new_user_session_path
    end
  end

  private
  def force_password_change
    if current_user.nil? or not current_user.password_changed?
      flash[:notice] = "Welcome, new user! Please change your password."
      redirect_to edit_user_registration_path
    end
  end

end
