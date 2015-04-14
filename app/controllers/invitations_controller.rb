class InvitationsController < Devise::InvitationsController
  def new
    if current_user.admin?
      super
    else
      flash[:notice] = INVITE_REFUSED
      redirect_to root_path
    end
  end
end
