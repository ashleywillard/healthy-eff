class ApplicationController < ActionController::Base
  protect_from_forgery
  include ErrorMessages, SimpleCaptcha::ControllerHelpers

  private
  def check_logged_in
    if not user_signed_in?
      redirect_to new_user_session_path
    end
  end

  private
  def force_password_change
    if current_user.nil? or not current_user.password_changed?
      flash[:notice] = WELCOME
      redirect_to edit_user_registration_path
    end
  end

  private
  def check_admin
    if not current_user.admin
      flash[:alert] = deny_access(get_current_page())
      redirect_to today_path
    end
  end

end
