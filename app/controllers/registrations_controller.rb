class RegistrationsController < Devise::RegistrationsController

  def update
    super
    if not params[:password].nil?
      current_user.password_changed = true
      current_user.save
    end
  end

end
