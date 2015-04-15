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

end
