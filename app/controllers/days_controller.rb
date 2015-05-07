class DaysController < ApplicationController
  include DateFormat

  before_filter :check_logged_in, :force_password_change

  def today
    restful_redirect
    @date = get_today(current_user.current_timezone)
    @day = Day.create_day(@date, true, "", current_user.current_timezone)
    @day.activities.append(Activity.new())
    month = Month.get_month_model(current_user.id, get_month(@date), get_year(@date))
    flash[:alert] = repeat_date(format_date(@date)) if month != nil && month.contains_date?(@date)
  end

  def past_days
    flash[:notice] = PAST_DAYS_SENT
    @month = Month.new()
    day = Day.new()
    @month.days.append(day)
    day.activities.append(Activity.new())
    today = get_today(current_user.current_timezone)
    @end_date = today.prev_day
    @start_date = get_day(today) < 6 ? today.ago(1.month).beginning_of_month : today.beginning_of_month
    @previously_inputted = Month.get_inputted_dates(current_user.id, @start_date, @end_date)
  end

  def restful_redirect
    if request.fullpath != '/today'
      flash.keep
      redirect_to today_path
    end
  end

  def check_simple_captcha
    if Rails.env.production?
      return simple_captcha_valid?
    else
      return true
    end
  end

  def error_recovery(error)
    flash[:notice] = nil
    flash[:alert] = error.message if flash[:alert] == nil
  end

  def bad_captcha
    flash[:alert] = BAD_CAPTCHA
    raise Exception
  end

  def empty_fields_notice
    flash[:alert] = EMPTY_FIELDS
    raise Exception
  end

  def add_today
    begin
      add(false, :day, :activities_attributes)
    rescue Exception => e
      error_recovery(e)
      redirect_to today_path
    end
  end

  def add_days
    begin
      add(true, :month, :days_attributes)
    rescue Exception => e
      error_recovery(e)
      redirect_to past_days_path
    end
  end

  def add(has_past_days, outer_sym, inner_sym)
    bad_captcha unless check_simple_captcha
    empty_fields_notice() if params[outer_sym] == nil || params[outer_sym][inner_sym] == nil
    if has_past_days then create_past_days() else create_single_day(params[outer_sym], true) end
    redirect_to calendar_path #success
  end

  def create_single_day(day, approved)
    date = day[:date]
    date = Time.strptime(date, "%m/%d/%Y") unless approved
    @day = Day.create_day(date, approved, params[:days][:reason], current_user.current_timezone)
    flash[:notice] = "" if flash[:notice] == nil
    flash[:notice] += @day.save_with_activities(validate_single_day(day[:activities_attributes], @day))
    update_month(@day)
  end

  def create_past_days
    params[:month][:days_attributes].each do |id, day|
      empty_fields_notice() if day[:activities_attributes] == nil
      check_day(day)
    end
    save_past_days()
  end

  def check_day(day)
    begin
      date = Time.strptime(day[:date], "%m/%d/%Y")
      @day = Day.create_day(date, false, params[:days][:reason], current_user.current_timezone)
      validate_single_day(day[:activities_attributes], @day)
    rescue ArgumentError
      #case where Date.parse throws an ArgumentError for having invalid date field
      flash[:alert] = INVALID_DATE
      raise Exception
    end
  end

  def validate_single_day(activity_list, day)
    activities = validate_single_day_activities(activity_list, day)
    validate_model(day)
    check_date_already_input(day.get_date_in_correct_timezone)
    return activities
  end

  def validate_single_day_activities(activity_list, day)
    activities = []
    activity_list.each do |id, activity|
      new_activity = Activity.create_activity(activity, day)
      validate_model(new_activity)
      activities += [new_activity]
    end
    return activities
  end

  def save_past_days
    params[:month][:days_attributes].each do |id, day|
      create_single_day(day, false)
    end
  end

  def validate_model(model)
    unless model.valid?
      flash[:alert] = model.errors.full_messages[0]
      raise Exception
    end
  end

  def check_date_already_input(date)
    month = Month.get_month_model(current_user.id, get_month(date), get_year(date))
    return unless month != nil && month.contains_date?(date)
    flash[:alert] = repeat_date format_date(date)
    raise Exception
  end

  def update_month(day)
    correct_day = day.get_date_in_correct_timezone
    month_model = Month.get_or_create_month_model(current_user.id, get_month(correct_day), get_year(correct_day))
    month_model.num_of_days += 1 if day.approved
    month_model.save!
    day.month_id = month_model.id
    day.save!
  end

end
