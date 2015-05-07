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
    unless params[:user] == nil
      timezone = params[:user][:current_timezone]
      if current_user.current_timezone != timezone
        current_user.update_attributes(:current_timezone => timezone)
        flash[:notice] = UPDATE_SUCCESSFUL
      end
    end
    redirect_to edit_user_registration_path
  end

end
