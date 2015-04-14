class RegistrationsController < Devise::RegistrationsController

  def update
    if not params[:user][:password].nil?
      current_user.password_changed = true
      current_user.save
    end
    super
  end

end
