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
    # TO DO
  end

  # function to approve a single pending activity
  def approve
    # TO DO
    # display a flash message and redirect back to pending page?
  end

  private
  def check_admin
    if current_user.nil?
      redirect_to new_user_session_path
    elsif not current_user.admin
      flash[:notice] = "You don't have permission to access this."
      flash.keep
      redirect_to today_path
    end
  end

  # potentially ashley/allan's stuff for adding and removing employees?
  # might also be in UsersController, depending on their implementation

end