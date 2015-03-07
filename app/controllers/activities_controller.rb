class ActivitiesController < ApplicationController

	def today
		#@activity = Activity.find params[:id]
		now = DateTime.now
		@date = now.strftime("%m/%d/%Y")
	end

	def add_activity
		
	end

end
