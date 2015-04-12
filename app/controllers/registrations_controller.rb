class RegistrationsController < Devise::RegistrationsController

  def update
    current_user.password_changed = true
    current_user.save
    super
  end

end
