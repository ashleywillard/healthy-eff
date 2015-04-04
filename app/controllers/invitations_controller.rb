class InvitationsController < Devise::InvitationsController
  def new
    if current_user.admin?
    super
    else
      flash[:notice] = "You are not authorized to send invites!"
      redirect_to root_path
    end
  end
end
