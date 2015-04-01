class ActivitiesController < ApplicationController

  before_filter :check_logged_in

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
                      :denied => false,
                      :user_id => current_user.id})
  end

  def multiple_days
    @user = current_user
    today = Date.today
    @end_date = today.prev_day
    @start_date = today.strftime("%d").to_i < 6 ? today.ago(1.month).beginning_of_month : today.beginning_of_month
  end

  def check_simple_captcha
    if Rails.env.production?
      return simple_captcha_valid?
    else
      return true
    end
  end

  def bad_captcha
    flash[:notice] = "Bro, your captcha was so wrong dude."
    raise Exception
  end

  def empty_fields_notice
    flash[:notice] = "Fields are empty"
    raise Exception
  end

  def add_activity
    begin
      add(false, :day, :activities_attributes)
    rescue Exception
      redirect_to today_path
    end
  end

  def add_days
    begin
      add(true, :user, :days_attributes)
    rescue Exception
      redirect_to multiple_days_path
    end
  end

  def add(has_multiple_days, outer_sym, inner_sym)
    bad_captcha unless check_simple_captcha
    empty_fields_notice() if params[outer_sym] == nil || params[outer_sym][inner_sym] == nil
    if has_multiple_days then create_multiple_days() else create_single_day(params[outer_sym], true) end
    redirect_to profile_path #success
  end

  def create_single_day(day, approved)
    @day = Day.new({:approved => approved,
                  :total_time => 0,
                  :denied => false,
                  :user_id => current_user,
                  :reason => params[:days][:reason]})
    unless approved
      @day.date = Time.strptime(day[:date], "%m/%d/%Y")
    else
      @day.date = day[:date]
    end
    save_single_day(validate_single_day(day[:activities_attributes], @day), @day)
    update_month(@day)
  end

  def create_multiple_days
    params[:user][:days_attributes].each do |id, day|
      empty_fields_notice() if day[:activities_attributes] == nil
      check_day(day)
    end
    save_multiple_days()
  end

  def check_day(day)
    begin
      date = Time.strptime(day[:date], "%m/%d/%Y")
      @day = Day.new({:date => date,
                    :approved => false,
                    :denied => false,
                    :total_time => 0,
                    :user_id => current_user,
                    :reason => params[:days][:reason]})
      validate_single_day(day[:activities_attributes], @day)
    rescue ArgumentError
      #case where Date.parse throws an ArgumentError for having invalid date field
      flash[:notice] = "Date is invalid"
      raise Exception
    end
  end

  def validate_single_day(activity_list, day)
    activities = validate_single_day_activities(activity_list, day)
    validate_model(day)
    return activities
  end

  def validate_single_day_activities(activity_list, day)
    activities = []
    activity_list.each do |id, activity|
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

  def save_multiple_days
    params[:user][:days_attributes].each do |id, day|
      create_single_day(day, false)
    end
  end

  def save_single_day(activities, day)
    notice = ""
    activities.each do |activity|
      day.save!
      activity.day_id = day.id
      activity.save!
      notice += "#{activity.name} for #{activity.duration} minutes has been recorded for #{day.date.strftime("%m/%d/%Y")}\n"
    end
    if flash[:notice] == nil then flash[:notice] = notice else flash[:notice] = flash[:notice] + notice end
  end

  def validate_model(model)
    unless model.valid? 
      flash[:notice] = model.errors.full_messages[0]
      raise Exception
    end
  end

  def update_month(day)
    month = day.date.strftime("%m").to_i
    year = day.date.strftime("%Y").to_i
    month_model = Month.where(user_id: current_user.id, month: month, year: year).first
    if month_model == nil
      month_model = Month.create({:user_id => current_user.id, 
                   :month => month, 
                   :year => year, 
                   :printed_form => false, 
                   :received_form => false,
                   :num_of_days => 0})
    end
    month_model.num_of_days += 1
    month_model.save!
  end

end
