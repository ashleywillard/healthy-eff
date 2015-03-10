class ActivitiesController < ApplicationController

	def today
		#@activity = Activity.find params[:id]
		now = DateTime.now
		@date = now.strftime("%m/%d/%Y")
	end

	def add_activity
		if params[:activity][:name].lstrip == ""
			params[:activity][:name] = "A Healthy Activity"
		end
		@activity = Activity.create(
			{:name => params[:activity][:name].lstrip, :duration => params[:activity][:duration], :approved => true})
		@day = Day.create({:date => DateTime.now, :total => params[:activity][:duration]})
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
end
