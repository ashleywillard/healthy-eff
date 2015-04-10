class AdminController < ApplicationController

  before_filter :check_logged_in, :check_admin

  def index
    @month = Date.today.strftime("%B")
    @year = Date.today.strftime("%Y")
    @user_months = Month.where(:month => Date.today.strftime("%m"), :year => @year)
  end

  def pending
    @days = Day.where(:approved => false, :denied => false)
    if @days.nil? or @days.empty?
      flash[:notice] = NOTHING_PENDING
      redirect_to admin_list_path
    end
  end

  def update_pending
    if not params[:selected].nil?
      self.approve_or_deny(:approved) if params[:commit] == APPROVE
      self.approve_or_deny(:denied) if params[:commit] == DENY
    end
    redirect_to admin_pending_path
  end

  def approve_or_deny(action)
    params[:selected].each do |id|
      d = Day.find_by_id(id)
      d.approved = true if action == :approved
      d.denied = true if action == :denied
      d.save
    end
    flash[:notice] = "Success! Activities #{action}."
  end

  # function to generate PDF printout for a single employee (accounting sheet)
    # (?) RESTful: app.heroku.com/admin/accounting/:month/:id (?)
  # NOT YET IMPLEMENTED

  # function to generate PDF printout for all employees (audit sheet)
    # (?) RESTful: app.heroku.com/admin/audit/:month (?)
  # NOT YET IMPLEMENTED

  private
  def check_admin
    if not current_user.admin
      flash[:notice] = ACCESS_DENIED
      redirect_to today_path
    end
  end

  # potentially ashley/allan's stuff for adding and removing employees?
  # might also be in UsersController, depending on their implementation

end
