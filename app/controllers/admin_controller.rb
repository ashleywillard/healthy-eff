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
      flash[:notice] = "No activities pending approval."
      redirect_to admin_list_path
    end
  end

  def update_pending
    if not params[:selected].nil?
      self.approve_or_deny(:approved) if params[:commit] == "Approve"
      self.approve_or_deny(:denied) if params[:commit] == "Deny"
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

  def tally
    id = params[:id] # TODO: null check
    @first_name = User.find_by_id(id).first_name
    @last_name = User.find_by_id(id).last_name
    @date = Date.today
#     @month = Date.today.strftime("%B")
#     @year = Date.today.strftime("%Y")
    @num_days = Time.days_in_month(@date.month, @date.year) + 1
    @user_days = Month.where(:month => @date.strftime("%m"), :year => @date.strftime("%Y"), :user_id => id).first.num_of_days
    html = render_to_string(:layout => false, :action => "tally.html.haml")
    kit = PDFKit.new(html)
#     pdf = kit.to_pdf
    send_data(kit.to_pdf, :filename => "tally.pdf", :type => 'application/pdf', :disposition => "inline")
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
      flash[:notice] = "You don't have permission to access this."
      redirect_to today_path
    end
  end

  # potentially ashley/allan's stuff for adding and removing employees?
  # might also be in UsersController, depending on their implementation

end
