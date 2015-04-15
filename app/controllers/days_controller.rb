class DaysController < ApplicationController
  include DateFormat

  before_filter :check_logged_in, :force_password_change

  def today
    # #RESTFUL redirecting
    # if request.fullpath != '/today'
    #   flash.keep
    #   redirect_to today_path
    # end
    @date = Date.today
    @day = Day.new({:date => @date,
                      :reason => "",
                      :approved => true,
                      :denied => false})
    @day.activities.append(Activity.new())
    month = Month.get_month_model(current_user.id, get_month(@date), get_year(@date))
    flash[:notice] = repeat_date(format_date(@date)) if month != nil && month.contains_date?(@date)
  end

  def past_days
    @month = Month.new()
    day = Day.new()
    @month.days.append(day)
    day.activities.append(Activity.new())
    today = Date.today
    @end_date = today.prev_day
    @start_date = get_day(today) < 6 ? today.ago(1.month).beginning_of_month : today.beginning_of_month
    @previously_inputted = Month.get_inputted_dates(current_user.id, @start_date, @end_date)
  end

  def check_simple_captcha
    if Rails.env.production?
      return simple_captcha_valid?
    else
      return true
    end
  end

  def bad_captcha
    flash[:notice] = BAD_CAPTCHA
    raise Exception
  end

  def empty_fields_notice
    flash[:notice] = EMPTY_FIELDS
    raise Exception
  end

  def add_today
    begin
      add(false, :day, :activities_attributes)
    rescue Exception
      redirect_to today_path
    end
  end

  def add_days
    begin
      add(true, :month, :days_attributes)
    rescue Exception
      redirect_to past_days_path
    end
  end

  def add(has_past_days, outer_sym, inner_sym)
    bad_captcha unless check_simple_captcha
    empty_fields_notice() if params[outer_sym] == nil || params[outer_sym][inner_sym] == nil
    if has_past_days then create_past_days() else create_single_day(params[outer_sym], true) end
    redirect_to profile_path #success
  end

  def create_single_day(day, approved)
    @day = Day.new({:approved => approved,
                  :total_time => 0,
                  :denied => false,
                  :reason => params[:days][:reason]})
    unless approved
      @day.date = Time.strptime(day[:date], "%m/%d/%Y")
    else
      @day.date = day[:date]
    end
    save_single_day(validate_single_day(day[:activities_attributes], @day), @day)
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
      @day = Day.new({:date => date,
                    :approved => false,
                    :denied => false,
                    :total_time => 0,
                    :reason => params[:days][:reason]})
      validate_single_day(day[:activities_attributes], @day)
    rescue ArgumentError
      #case where Date.parse throws an ArgumentError for having invalid date field
      flash[:notice] = INVALID_DATE
      raise Exception
    end
  end

  def validate_single_day(activity_list, day)
    activities = validate_single_day_activities(activity_list, day)
    validate_model(day)
    check_date_already_input(day.date)
    return activities
  end

  def validate_single_day_activities(activity_list, day)
    activities = []
    activity_list.each do |id, activity|
      session[:name] = activity[:name]
      new_activity = create_activity(activity, day)
      validate_model(new_activity)
      activities += [new_activity]
    end
    return activities
  end

  def create_activity(activity, day)
    name = activity[:name].lstrip
    duration = activity[:duration]
    day.total_time += duration.to_i
    if name == "" then name = "A Healthy Activity" end
    @activity = Activity.new({:name => name,
                              :duration => duration})
  end

  def save_past_days
    params[:month][:days_attributes].each do |id, day|
      create_single_day(day, false)
    end
  end

  def save_single_day(activities, day)
    notice = ""
    activities.each do |activity|
      day.save!
      activity.day_id = day.id
      activity.save!
      notice += activity_recorded(activity.name, activity.duration, format_date(day.date))
    end
    if flash[:notice] == nil then flash[:notice] = notice else flash[:notice] = flash[:notice] + notice end
  end

  def validate_model(model)
    unless model.valid?
      flash[:notice] = model.errors.full_messages[0]
      raise Exception
    end
  end

  def check_date_already_input(date)
    month = Month.get_month_model(current_user.id, get_month(date), get_year(date))
    return unless month != nil && month.contains_date?(date)
    flash[:notice] = repeat_date format_date(date)
    raise Exception
  end

  def update_month(day)
    month_model = Month.get_or_create_month_model(current_user.id, get_month(day.date), get_year(day.date))
    month_model.num_of_days += 1
    month_model.save!
    day.month_id = month_model.id
    day.save!
  end

end
