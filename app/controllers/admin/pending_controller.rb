class Admin::PendingController < Admin::AdminController

  def index
    @days = Day.where(:approved => false, :denied => false)
    if @days.blank?
      flash[:notice] = NOTHING_PENDING
      redirect_to admin_list_path
    end
  end

  def update
    if not params[:selected].nil?
      self.approve_or_deny(:approved) if params[:commit] == APPROVE
      self.approve_or_deny(:denied) if params[:commit] == DENY
    end
    redirect_to admin_pending_path
  end

  def approve_or_deny(action)
    params[:selected].each do |id|
      d = Day.find_by_id(id)
      d.approve_day if action == :approved
      d.denied = true if action == :denied
      d.save
    end
    flash[:notice] = activities_action(action)
  end

end
