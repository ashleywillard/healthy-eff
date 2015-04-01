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
    @workouts = populate_workouts(@curr_user_month)
  end

  
  def populate_workouts(curr_month)
    workouts = []
    curr_month.days each |day| do
      day.activities each |activity| do
        workouts.push(day, activity)	
      end
    end
  end

end
