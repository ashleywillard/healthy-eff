class ActivitiesController < ApplicationController
  
  before_filter :check_logged_in

  def today
    @date = DateTime.now.strftime("%m/%d/%Y")
    @day = Day.new({:date => @date,
                      :reason => "", 
                      :approved => true,
                      :user_id => current_user})
  end

  def multiple_days
    @user = User.find(current_user)
  end

  def check_simple_captcha
    simple_captcha_valid?
    # true
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
        if add_single_day(params[:day][:activities_attributes], true, @date)
          redirect_to profile_path
        else
          redirect_to today_path
        end
      else
        empty_fields_notice()
        redirect_to today_path
      end
    end
  end

  def add_single_day(activity_list, approved, date)
    @day = Day.new({:date => date,
                    :approved => approved,
                    :total_time => 0,
                    :user_id => current_user,
                    :reason => params[:days][:reason]})
    activities = []
    activities_valid = true

    activity_list.each do |id, activity|
      new_activity = create_activity(activity, @day)
      activities += [new_activity]
      activities_valid = activities_valid && new_activity.valid?
      flash[:notice] = flash[:notice] || new_activity.errors.full_messages[0]
    end

    unless activities_valid && @day.valid?
      flash[:notice] = flash[:notice] || @day.errors.full_messages[0]
      false # unsuccessful
    else
      save_single_day(activities, @day)
      true # successful
    end
  end

  def save_single_day(activities, day)
    notice = ""
    activities.each do |activity|
      activity.save
      day.save
      notice += "#{activity.name} for #{activity.duration} minutes has been recorded\n"
    end
    flash[:notice] = notice
  end

  def create_activity(activity, day)
    name = activity[:name].lstrip
    duration = activity[:duration]
    day.total_time += duration.to_i
    if name == "" then name = "A Healthy Activity" end
    @activity = Activity.new({:name => name,
                              :duration => duration,
                              :day_id => day.id})
  end

  def add_days
    unless check_simple_captcha
      bad_captcha
      redirect_to multiple_days_path
    else
      unless params[:user] == nil || params[:user][:days_attributes] == nil
        today = DateTime.now.strftime("%m/%d/%Y")
        success = true
        params[:user][:days_attributes].each do |id, day|
          unless day[:activities_attributes] == nil 
            unless add_single_day(day[:activities_attributes], day[:date] == today, day[:date])
              redirect_to multiple_days_path
              success = false
              break
            end
          else
            success = false
            empty_fields_notice()
            redirect_to multiple_days_path
            break
          end
        end
        if success then redirect_to profile_path end
      else
        empty_fields_notice()
        redirect_to multiple_days_path
      end
    end
  end

  private
  def check_logged_in
    if not user_signed_in?
      redirect_to new_user_session_path
    end
  end
end
