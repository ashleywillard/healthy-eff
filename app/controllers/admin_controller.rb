class AdminController < ApplicationController
  include DateFormat
  before_filter :check_logged_in, :check_admin, :force_password_change

  # Admin list view
  def index
    session[:months_ago] ||= 0
    session[:months_ago] += 1 if params[:navigate] == "Previous"
    session[:months_ago] -= 1 if params[:navigate] == "Next"
    @date = get_date()
    @user_months = Month.where(:month => get_month(@date), :year => get_year(@date))
  end

  # Activities pending approval
  def pending
    @days = Day.where(:approved => false, :denied => false)
    if @days.nil? or @days.empty?
      ###### added nothing_pending
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
    ###### changed to activities_action method
    flash[:notice] = activities_action(action)
  end

  # Generate PDF for individual accounting sheet
  def accounting
    @user = User.find_by_id(params[:id])
    @date = get_date()
    @num_days = Time.days_in_month(@date.month, @date.year)
    records = Month.get_month_model(params[:id], @date.month, @date.year)
    if records.nil?
      handle_no_records()
    else
      @user_days = records.num_of_days
      generate_pdf("accounting", "acct-#{@user.last_name}-#{get_month_name(@date)}-#{get_year(@date)}.pdf")
    end
  end

  # Generate PDF for all employees this month (audit sheet)
  def audit
    @date = session[:months_ago].to_i.months.ago
    @user_months = Month.where(:month => @date.strftime("%m"), :year => @date.strftime("%Y"))
    generate_pdf("audit", "audit-#{get_month_name(@date)}-#{get_year(@date)}.pdf")
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

  def handle_no_records
    flash[:notice] = "No recorded activities for #{@user.first_name} #{@user.last_name} for #{@date.strftime("%B")} #{@date.strftime("%Y")}."
    redirect_to admin_list_path
  end

  def get_date
    session[:months_ago].to_i.months.ago
  end

  private
  def check_admin
    if not current_user.admin
      ###### changed to deny_access method
      flash[:notice] = deny_access get_current_page
      redirect_to today_path
    end
  end

end
