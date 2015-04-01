class UsersController < ApplicationController

  def profile
  	@now = DateTime.now
  	@currentMonth = @now.strftime('%m').to_i
    @currentYear = @now.strftime('%Y').to_i

    @previousMonth = @currentMonth - 1
    @previousYear = @currentYear
    if @currentMonth== 0
      @previousMonth = 12
      @previousYear -= 1
    end

    @curr_user_month = Month.where(:month => @currentMonth, 
    							                 :year => @currentMonth, 
    							                 :user_id => current_user.id)
    @prev_user_month = Month.where(:month => @previousMonth, 
    							                 :year => @previousYear, 
    							                 :user_id => current_user.id)	
  end

   #  @workouts = []
   #  def populate_events 
	  #   @curr_user_month.days each |day| do
	  #   	day.activities each |day| do
	  #   		workouts.add(day.date, activity.activity)	
   #  		end
  	# 	end
  	# end
end
