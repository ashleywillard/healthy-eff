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
		@activity = Activity.create(params[:activity])
		@day = Day.create({:date => DateTime.now, :total_time => params[:activity][:duration], , :approved => true})
		@activity.day = @day
		#@day.user = current_user
		if @activity.valid? && @day.valid?
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
