class ApplicationController < ActionController::Base
  protect_from_forgery
  include SimpleCaptcha::ControllerHelpers

  private
  def check_logged_in
    if not user_signed_in?
      redirect_to new_user_session_path
    end
  end

  ACCESS_DENIED = "Access to this page is restriced to administrators."

  INVITE_REFUSED = "You are not authorized to invite other users."

  NOTHING_PENDING = "No activities pending approval."

  APPROVE = "Approve"

  DENY = "Deny"

  BAD_CAPTCHA = "Incorrect captcha."

  EMPTY_FIELDS = "Some required fields were left blank."

  INVALID_DATE = "Invalid date."

end
