class ActivitiesController < ApplicationController
  
  before_filter :check_logged_in

  def today
    # #RESTFUL redirecting
    # if request.fullpath != '/today'
    #   flash.keep
    #   redirect_to today_path
    # end
    @date = DateTime.now
    @day = Day.new({:date => @date,
                      :reason => "", 
                      :approved => true,
                      :user_id => current_user})
  end

  def multiple_days
    @user = User.find(current_user)
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
  end

  def empty_fields_notice
    flash[:notice] = "Fields are empty"
  end

  def add_activity
    unless check_simple_captcha
      bad_captcha
      redirect_to today_path
    else
      unless params[:day] == nil || params[:day][:activities_attributes] == nil
        check_today()
      else
        empty_fields_notice()
        redirect_to today_path
      end
    end
  end

  def add_days
    unless check_simple_captcha
      bad_captcha
      redirect_to multiple_days_path
    else
      unless params[:user] == nil || params[:user][:days_attributes] == nil
        check_multiple_days()
      else
        empty_fields_notice()
        redirect_to multiple_days_path
      end
    end
  end

  def check_today
    begin
      @day = Day.new({:date => params[:day][:date],
                    :approved => true,
                    :total_time => 0,
                    :user_id => current_user,
                    :reason => params[:days][:reason]})
      save_single_day(validate_single_day(params[:day][:activities_attributes], @day), @day)
      redirect_to profile_path
    rescue Exception
      redirect_to today_path
    end
  end

  def check_multiple_days
    begin
      validate_multiple_days()
      save_multiple_days()
      redirect_to profile_path
    rescue Exception
      redirect_to multiple_days_path
    end
  end

  def validate_multiple_days
    params[:user][:days_attributes].each do |id, day|
      unless day[:activities_attributes] == nil
        check_day(day)
      else
        empty_fields_notice()
        raise Exception
      end
    end
  end

  def check_day(day)
    begin
      date = Date.parse(day[:date]).strftime("%m/%d/%Y")
      @day = Day.new({:date => date,
                    :approved => false,
                    :total_time => 0,
                    :user_id => current_user,
                    :reason => params[:days][:reason]})
      validate_single_day(day[:activities_attributes], @day)
    rescue ArgumentError
      flash[:notice] = "Invalid Date"
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
      activities += [new_activity]
      validate_model(new_activity)
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

  def save_multiple_days
    params[:user][:days_attributes].each do |id, day|
      @day = Day.new({:date => Date.parse(day[:date]).strftime("%m/%d/%Y"),
                  :approved => false,
                  :total_time => 0,
                  :user_id => current_user,
                  :reason => params[:days][:reason]})
      save_single_day(validate_single_day(day[:activities_attributes], @day), @day)
    end
  end

  def validate_model(model)
    unless model.valid? 
      flash[:notice] = model.errors.full_messages[0]
      raise Exception
    end
  end

  private
  def check_logged_in
    if not user_signed_in?
      redirect_to new_user_session_path
    end
  end
end
