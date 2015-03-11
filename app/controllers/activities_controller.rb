class ActivitiesController < ApplicationController
    
    before_filter :check_logged_in

	def today
		#@activity = Activity.find params[:id]
		now = DateTime.now
		@date = now.strftime("%m/%d/%Y")
	end

	def add_activity
		params[:activity][:name] = params[:activity][:name].lstrip

		if params[:activity][:name] == ""
			params[:activity][:name] = "A Healthy Activity"
		end
		@activity = Activity.new(params[:activity])
		@day = Day.new({:date => DateTime.now.strftime("%m/%d/%Y"), :total_time => params[:activity][:duration], :approved => true})
		if @activity.valid? && @day.valid?
			@activity.day = @day
			@day.user = current_user
			@activity.save
			@day.save
	
			flash[:notice] = "#{@activity.name} for #{@activity.duration} minutes has been recorded"
			redirect_to profile_path
		else
			if @activity.errors.full_messages[0] != nil
				flash[:notice] = @activity.errors.full_messages[0] 
			else
				flash[:notice] = @day.errors.full_messages[0]
			end
			redirect_to today_path
		end
		
	end

	private
    def check_logged_in
      if not user_signed_in?
        redirect_to new_user_session_path
      end
    end
end
