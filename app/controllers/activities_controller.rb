class ActivitiesController < ApplicationController
    
    before_filter :check_logged_in

    def today
        #@activity = Activity.find params[:id]
        now = DateTime.now
        @date = now.strftime("%m/%d/%Y")
    end

    def check_simple_captcha
      simple_captcha_valid?
      #true
    end

    def add_activity
        unless check_simple_captcha
          flash[:notice] = "Bro, your captcha was so wrong dude."
          redirect_to today_path
        else
          params[:activity][:name] = params[:activity][:name].lstrip

          if params[:activity][:name] == "" then params[:activity][:name] = "A Healthy Activity" end
          
          @day = Day.new({:date => DateTime.now.strftime("%m/%d/%Y"), 
                          :total_time => params[:activity][:duration], 
                          :reason => "", 
                          :approved => true})
          @day.user = current_user
          @activity = Activity.new(params[:activity])
          @activity.day = @day
          
          if @activity.valid? && @day.valid?
              @activity.save
              @day.save
              flash[:notice] = "#{@activity.name} for #{@activity.duration} minutes has been recorded"
              redirect_to profile_path
          else
              flash[:notice] = @activity.errors.full_messages[0] != nil ? @activity.errors.full_messages[0] : @day.errors.full_messages[0]
              redirect_to today_path
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
