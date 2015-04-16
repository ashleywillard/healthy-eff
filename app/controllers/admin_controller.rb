class AdminController < ApplicationController
  include DateFormat

  before_filter :check_logged_in, :check_admin, :force_password_change

  # :get for list view
  def index
    session[:sort] = params[:sort] if not params[:sort].nil?
    navigate_months()
    @date = get_date()
    @user_months = Month.get_user_months(get_month(@date), get_year(@date))
    @user_months = sort_admin_list(@user_months)
    @user_months = @user_months.reject{ |x| x.get_num_approved_days() == 0 }
  end

  # :get for pending activities
  def pending
    @days = Day.where(:approved => false, :denied => false)
    if @days.nil? or @days.empty?
      flash[:notice] = "No activities pending approval."
      redirect_to admin_list_path
    end
  end

  # :put for pending activities
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
      d.approve_day if action == :approved
      d.denied = true if action == :denied
      d.save
    end
    flash[:notice] = "Success! Activities #{action}."
  end

  # :get for accounting sheet PDF
  def accounting
    @user = User.find_by_id(params[:id])
    @date = get_date()
    @num_days = Time.days_in_month(@date.month, @date.year)
    @records = Month.get_month_model(params[:id], @date.month, @date.year)
    if @records.nil? or @records.get_num_approved_days() == 0
      handle_no_records()
    else
      @user_days = @records.get_num_approved_days()
      generate_pdf("accounting", "acct-#{@user.last_name}-#{get_month_name(@date)}-#{get_year(@date)}.pdf")
    end
  end

  def group_accounting
    html = ""
    @date = get_date()
    @num_days = Time.days_in_month(@date.month, @date.year)
    redirect_to admin_list_path and return if params[:selected].nil?
    params[:selected].each do |m_id|
      if m_id == params[:selected][0] ; @first = true ; else ; @first = false ; end
      @user = User.find_by_id(Month.find_by_id(m_id).user.id)
      @records = Month.get_month_model(@user.id, @date.month, @date.year)
      if @records.nil?
        @user_days = 0
      else
        @user_days = @records.get_num_approved_days()
      end
      html << render_to_string(:layout => false, :action => 'accounting.html.haml')
      kit = PDFKit.new(html)
      kit.stylesheets << "#{Rails.root}/app/assets/stylesheets/pdf.css"
      send_data(kit.to_pdf, :filename => "acct-#{get_month_name(@date)}-#{get_year(@date)}.pdf",
                            :type => 'application/pdf',
                            :disposition => "inline")
    end
  end

  # :get for audit sheet PDF
  def audit
    @date = session[:months_ago].to_i.months.ago
    @user_months = Month.find(:all, :conditions => {:month => get_month(@date), :year => get_year(@date)},
                              :joins => :user, :order => 'users.last_name')
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

  def sort_admin_list(list)
    list.joins(:user).order("users." + session[:sort])
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
      flash[:notice] = "You don't have permission to access this."
      redirect_to today_path
    end
  end

end
