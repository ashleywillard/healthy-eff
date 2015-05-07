class RegistrationsController < Devise::RegistrationsController

  def update
    if not current_user.password_changed?
      if new_password_provided?
        current_user.password_changed = true
        current_user.save
      end
    end
    super
  end

  def new_password_provided?
    not params[:user][:password].blank?
  end

  def update_user_timezone
    form_timezone = current_user.current_timezone
    if params[:user] != nil && params[:user][:current_timezone] != nil
      form_timezone = params[:user][:current_timezone]
    end
    if current_user.current_timezone != form_timezone
      current_user.update_attributes(:current_timezone => form_timezone)
    end
    redirect_to  edit_user_registration_path
  end

end
