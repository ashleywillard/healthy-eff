module ErrorMessages

  ACCESS_DENIED = " page is restriced to administrators."

  def get_current_page
    path = Rails.application.routes.recognize_path(request.env['PATH_INFO'])
    path[:action]
  end

  def deny_access(page)
    "Access to the '#{page.capitalize}'" + ACCESS_DENIED
  end

  ACTION_COMPLETE = "Success! Activities "
  def activities_action(action)
    ACTION_COMPLETE + "#{action}."
  end

  USER_DELETED = " has been deleted."
  def user_deleted(first_name, last_name)
    "User #{first_name} #{last_name}" + USER_DELETED
  end

  INVITE_REFUSED = "You are not authorized to invite other users."

  NOTHING_PENDING = "No activities pending approval."

  APPROVE = "Approve"

  DENY = "Deny"

  def action_complete(action)
    ACTION_COMPLETE + " #{action}."
  end

  BAD_CAPTCHA = "Incorrect captcha."

  EMPTY_FIELDS = "Some required fields were left blank."

  INVALID_DATE = "Invalid date."
  def invalid_date
    INVALID_DATE
  end

  def activity_recorded(name, duration, date)
    if date == ""
      return "#{name.capitalize} for #{duration} minutes has been recorded for"
    end
    "#{name.capitalize} for #{duration} minutes has been recorded for #{date}.\n"
  end

  REPEAT_DATE = " has already been inputted."
  def repeat_date(date)
    "#{date}" + REPEAT_DATE
  end

  NOT_BLANK = "can't be blank"
end
#World(ErrorMessages)