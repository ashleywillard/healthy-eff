module ErrorMessages

  def get_current_page
    begin
      path = Rails.application.routes.recognize_path(request.env['PATH_INFO'])
      path[:action]
    rescue
      ""
    end
  end

  ACCESS_DENIED ||= " page is restricted to administrators."
  def deny_access(page)
    "Access to the '#{page.capitalize}'" + ACCESS_DENIED
  end
  def access_denied
    ACCESS_DENIED
  end

  ACTION_COMPLETE ||= "Success! Activities "
  def activities_action(action)
    ACTION_COMPLETE + "#{action}."
  end

  RECEIVED_FORM ||= "Forms marked as received."

  UPDATE_SUCCESSFUL ||= "Settings were successfully updated."

  USER_DELETED ||= " has been deleted."
  def user_deleted(first_name, last_name)
    if (first_name == "")
      return "User #{last_name}" + USER_DELETED
    end
    "User #{first_name} #{last_name}" + USER_DELETED
  end

  INVITE_REFUSED ||= "You are not authorized to invite other users."
  def invite_refused
    INVITE_REFUSED
  end

  NOTHING_PENDING ||= "No activities pending approval."
  def nothing_pending
    NOTHING_PENDING
  end

  def action_complete(action)
    ACTION_COMPLETE + " #{action}."
  end

  BAD_CAPTCHA ||= "Incorrect captcha."
  def bad_captcha
    BAD_CAPTCHA
  end

  EMPTY_FIELDS ||= "Some required fields were left blank."
  def empty_fields
    EMPTY_FIELDS
  end

  INVALID_DATE ||= "Invalid date."
  def invalid_date
    INVALID_DATE
  end

  def activity_recorded(name, duration, date)
    if date == ""
      return "#{name.capitalize} for #{duration} minutes has been recorded for"
    end
    "#{name.capitalize} for #{duration} minutes has been recorded for #{date}.\n"
  end

  REPEAT_DATE ||= " has already been inputted."
  def repeat_date(date)
    "#{date}" + REPEAT_DATE
  end

  NOT_BLANK ||= "can't be blank"
  NOT_BELOW_ZERO ||= "can't be less than 0"
  NOT_TOO_HIGH ||= "can't be over 24 hours"
  NOT_ENOUGH ||= "can't be less than 60 mins"

  def date_out_of_range(date)
    date + " is not within allowed range. Note: You only have until the 5th of the month to input days for the previous month."
  end

  WELCOME ||= "Welcome, new user! Please change your password."
  def welcome
    WELCOME
  end

  PAST_DAYS_SENT ||= "Activities for all past days will be sent to admin for approval."
  def past_days_sent
    PAST_DAYS_SENT
  end

  HEALTHY_ACTIVITY ||= "A Healthy Activity"
  def healthy_activity
    HEALTHY_ACTIVITY
  end

  LOWERCASE_MISSING ||= "must include at least one lowercase character"
  def lowercase_missing
    "Password " + LOWERCASE_MISSING
  end

  UPPERCASE_MISSING ||= "must include at least one uppercase character"
  def uppercase_missing
    "Password " + UPPERCASE_MISSING
  end

  NUMBER_MISSING ||= "must include at least one number"
  def number_missing
    "Password " + NUMBER_MISSING
  end

  SPECIAL_MISSING ||= "must include at least one special character"
  def special_missing
    "Password " + SPECIAL_MISSING
  end

  # action constants for pending activities
  APPROVE ||= "Approve"
  DENY ||= "Deny"

end
#World(ErrorMessages)
