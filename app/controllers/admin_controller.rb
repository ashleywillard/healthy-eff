class AdminController < ApplicationController

  before_filter :check_logged_in, :check_admin, :force_password_change

  # Admin list view
  def index
    session[:months_ago] ||= 0
    @months_ago = session[:months_ago]
    if not params[:navigate].nil?
      @months_ago += 1 if params[:navigate] == "Previous"
      @months_ago -=1 if params[:navigate] == "Next"
      session[:months_ago] = @months_ago
    end
    d = @months_ago.to_i.months.ago
    @month = d.strftime("%B")
    @year = d.strftime("%Y")
    @user_months = Month.where(:month => d.strftime("%m"), :year => @year)
  end

  # Activities pending approval
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

  # Generate PDF for individual accounting sheet
  def accounting
    id = params[:id] ; u = User.find_by_id(id)
    @first_name = u.first_name ; @last_name = u.last_name

    @date = Date.today # CHANGE TO REFLECT MONTH CURRENTLY BEING VIEWED
    @num_days = Time.days_in_month(@date.month, @date.year) + 1 # +1 here as test for 31 days
    records = Month.where(:month => @date.strftime("%m"),
                          :year => @date.strftime("%Y"),
                          :user_id => id).first
    if records.nil?
      flash[:notice] = "No recorded activities for #{@first_name} #{@last_name} for #{@date.strftime("%B")} #{@date.strftime("%Y")}."
      redirect_to admin_list_path and return
    else
      @user_days = records.num_of_days
    end

    html = render_to_string(:layout => false, :action => "accounting.html.haml")
    kit = PDFKit.new(html)
    send_data(kit.to_pdf, :filename => "accounting.pdf", :type => 'application/pdf', :disposition => "inline")
  end

  # Generate PDF for all employees this month (audit sheet)
  def audit
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
