class AdminController < ApplicationController

  before_filter :check_logged_in, :check_admin, :force_password_change

  # Admin list view
  def index
    session[:months_ago] ||= 0
    session[:months_ago] += 1 if params[:navigate] == "Previous"
    session[:months_ago] -= 1 if params[:navigate] == "Next"
    @date = session[:months_ago].to_i.months.ago
    @user_months = Month.where(:month => @date.strftime("%m"),
                               :year => @date.strftime("%Y"))
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
    @user = User.find_by_id(params[:id])
    @date = session[:months_ago].to_i.months.ago # CHANGE TO REFLECT MONTH CURRENTLY BEING VIEWED
    @num_days = Time.days_in_month(@date.month, @date.year) + 1 # +1 here as test for 31 days
    records = Month.where(:month => @date.strftime("%m"),
                          :year => @date.strftime("%Y"),
                          :user_id => params[:id]).first
    if records.nil?
      flash[:notice] = "No recorded activities for #{@first_name} #{@last_name} for #{@date.strftime("%B")} #{@date.strftime("%Y")}."
      redirect_to admin_list_path and return
    else
      @user_days = records.num_of_days
    end
    generate_pdf("accounting", "acct-#{@last_name}-#{@date.strftime("%B")}-#{@date.strftime("%Y")}.pdf")
  end

  # Generate PDF for all employees this month (audit sheet)
  def audit
    @date = Date.today # CHANGE ME
    @month_num = @date.strftime("%m")
    @year = @date.strftime("%Y")
    @user_months = Month.where(:month => @month_num, :year => @year)
    generate_pdf("audit", "audit-#{@date.strftime("%B")}-#{@date.strftime("%Y")}.pdf")
  end

  def generate_pdf(type, name)
    case type
      when 'audit'
        action = 'audit.html.haml'
        orientation = 'Landscape'
      when 'accounting'
        action = 'accounting.html.haml'
        orientation = 'Portrait'
    end
    html = render_to_string(:layout => false, :action => action)
    kit = PDFKit.new(html, :orientation => orientation)
    send_data(kit.to_pdf, :filename => name,
                          :type => 'application/pdf',
                          :disposition => "inline")
  end

  private
  def check_admin
    if not current_user.admin
      flash[:notice] = "You don't have permission to access this."
      redirect_to today_path
    end
  end

end
