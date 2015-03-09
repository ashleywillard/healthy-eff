class ActivitiesController < ApplicationController

	def today
		#@activity = Activity.find params[:id]
		now = DateTime.now
		@date = now.strftime("%m/%d/%Y")
	end

	def add_activity
		@activity = Activity.create!(params[:activity])
		Day.create!({:date => DateTime.now, :total => @activity.duration})
		flash[:notice] = "#{@activity.name} for #{@activity.duration} hours has been recorded"
		redirect_to profile_path
	end

end
