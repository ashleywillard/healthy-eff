class ActivitiesController < ApplicationController

  before_filter :check_logged_in

  def today
    #@activity = Activity.find params[:id]
    now = DateTime.now
    @date = now.strftime("%m/%d/%Y")
  end

  def add_activity
    @activity = Activity.create!(params[:activity])
    flash[:notice] = "#{@activity.name} for #{@activity.duration} hours has been recorded"
    redirect_to profile_path
  end

  private
  def check_logged_in
    if not user_signed_in?
      redirect_to new_user_session_path
    end
  end

end
