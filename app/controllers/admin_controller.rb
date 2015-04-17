class AdminController < ApplicationController
  include DateFormat

  before_filter :check_logged_in, :check_admin, :force_password_change

  # :get for list view
  def index
    session[:sort] = params[:sort] if not params[:sort].nil?
    navigate_months()
    @date = get_date()
    @user_months = sort(Month.get_user_months(get_month(@date), get_year(@date)))
    unless @user_months.nil?
      @user_months = @user_months.reject{ |x| x.get_num_approved_days() == 0 }
    end
  end

  # :get for pending activities
  def pending
    @days = Day.where(:approved => false, :denied => false)
    if @days.nil? or @days.empty?
      ###### added nothing_pending
      flash[:notice] = NOTHING_PENDING
      redirect_to admin_list_path
    end
  end

  # :put for pending activities
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
      d.approve_day if action == :approved
      d.denied = true if action == :denied
      d.save
    end
    ###### changed to activities_action method
    flash[:notice] = activities_action(action)
  end

  def accounting
    redirect_to admin_list_path and return if params[:selected].nil?
    @first = true
    @date = get_date()
    @num_days = Time.days_in_month(@date.month, @date.year)
    html = ""
    params[:selected].each do |m_id|
      @first = false if m_id == params[:selected][1] # insert page breaks
      generate_accounting_sheet(m_id)
      html << render_to_string(:layout => false, :action => 'accounting')
    end
    if params[:selected].length == 1
      pdf_name = "acct-#{@user.last_name}-#{get_month_name(@date)}-#{get_year(@date)}.pdf"
    else
      pdf_name = "acct-#{get_month_name(@date)}-#{get_year(@date)}.pdf"
    end
    generate_pdf("accounting", pdf_name, html)
  end

  # set up instance variables for use in the PDF views
  def generate_accounting_sheet(month_id)
    @user = Month.find_by_id(month_id).user
    @records = Month.get_month_model(@user.id, @date.month, @date.year)
    @records.nil? ? @user_days = 0 : @user_days = @records.get_num_approved_days()
  end

  # :get for audit sheet PDF
  def audit
    @date = session[:months_ago].to_i.months.ago
    @user_months = Month.find(:all, :conditions => {:month => get_month(@date), :year => get_year(@date)},
                              :joins => :user, :order => 'users.last_name')
    # NOTE: May have to change if we want all employees to be displayed, not just
    # the ones that have logged stuff this month
    html = render_to_string(:layout => false, :action => 'audit')
    generate_pdf("audit", "audit-#{get_month_name(@date)}-#{get_year(@date)}.pdf", html)
  end

  def generate_pdf(type, name, html)
    case type
      when 'audit'
        orientation = 'Landscape'
      when 'accounting'
        orientation = 'Portrait'
    end
    kit = PDFKit.new(html, :orientation => orientation)
    kit.stylesheets << "#{Rails.root}/app/assets/stylesheets/pdf.css"
    send_data(kit.to_pdf, :filename => name,
                          :type => 'application/pdf',
                          :disposition => "inline")
  end

  def navigate_months
    session[:months_ago] ||= 0
    session[:months_ago] += 1 if params[:navigate] == "Previous"
    session[:months_ago] -= 1 if params[:navigate] == "Next"
  end

  def sort(list)
    session[:sort].nil? ? list : list.joins(:user).order("users." + session[:sort])
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
