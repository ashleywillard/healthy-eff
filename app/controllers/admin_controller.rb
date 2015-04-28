class AdminController < ApplicationController
  include DateFormat

  before_filter :check_logged_in, :check_admin, :force_password_change

  # :get for list view
  def index
    session[:sort] = params[:sort] if not params[:sort].nil?
    navigate_months()
    @date = get_date()
    @user_months = Hash.new
    User.includes(:months).all.each do |user|
      @user_months[user] = Month.get_month_model(user.id, get_month(@date), get_year(@date))
    end
    @user_months = sort(@user_months)
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

  def navigate_months
    session[:months_ago] ||= 0
    case params[:navigate]
      when nil then session[:months_ago] = 0
      when "Previous" then session[:months_ago] += 1
      when "Next" then session[:months_ago] -= 1
    end
  end

  def sort(hash)
    case session[:sort]
      when "first_name"
        hash = hash.sort_by {|k, v| k.first_name.to_s}
      when "last_name"
        hash = hash.sort_by {|k, v| k.last_name.to_s}
      when "days"
        hash = hash.sort_by {|k, v| v.nil? ? 0 : v.get_num_approved_days().to_i}.reverse
    end
    return hash
  end

  def get_date
    session[:months_ago].to_i.months.ago
  end

end
