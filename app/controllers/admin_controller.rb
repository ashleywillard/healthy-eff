class AdminController < ApplicationController

  before_filter :check_logged_in, :check_admin

  # function to generate list of employees for the list view
    # RESTful: app.heroku.com/admin <-> admin_list_path
  def index
    @month = Date.today.strftime("%B")
    @year = Date.today.strftime("%Y")
    @user_months = Month.where(:month => Date.today.strftime("%m"), :year => @year)
  end

  # function to generate PDF printout for a single employee (accounting sheet)
    # (?) RESTful: app.heroku.com/admin/accounting/:month/:id (?)
  # NOT YET IMPLEMENTED

  # function to generate PDF printout for all employees (audit sheet)
    # (?) RESTful: app.heroku.com/admin/audit/:month (?)
  # NOT YET IMPLEMENTED

  # function to generate list of multiple-day activities for pending view
    # RESTful: app.heroku.com/admin/pending <-> admin_pending_path
  def pending
    @days = Day.where(:approved => false, :denied => false)
    if @days.nil? or @days.empty?
      flash[:notice] = "No activities pending approval."
      redirect_to admin_list_path
    end
  end

  # function to approve or deny selected pending activities
    # RESTful: app.heroku.com/admin/update_pending <-> admin_update_pending_path
  def update_pending
    if not params[:selected].nil?
      if params[:commit] == "Approve"
        self.approve
      elsif params[:commit] == "Deny"
        self.deny
      end
    end
    redirect_to admin_pending_path
  end

  def approve
    params[:selected].each do |id|
      d = Day.find_by_id(id)
      d.approved = true
      d.save
    end
    flash[:notice] = "Success! Activities approved."
  end

  def deny
    params[:selected].each do |id|
      d = Day.find_by_id(id)
      d.denied = true
      d.save
    end
    flash[:notice] = "Success! Activities denied."
  end

  private
  def check_admin
    if not current_user.admin
      flash[:notice] = "You don't have permission to access this."
      redirect_to today_path
    end
  end

  # potentially ashley/allan's stuff for adding and removing employees?
  # might also be in UsersController, depending on their implementation

end
