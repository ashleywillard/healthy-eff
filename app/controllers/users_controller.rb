class UsersController < ApplicationController

  def profile
  	@now = DateTime.now
  	@currentMonth = @now.strftime('%m').to_i
    @currentYear = @now.strftime('%Y').to_i

    @previousMonth = @currentMonth - 1
    @previousYear = @currentYear
    if @currentMonth== 0
      @pseviousMonth = 12
      @previousYear -= 1
    end

    @curr_user_month = Month.where(:month => @currentMonth, 
    							                 :year => @currentYear,
    							                 :user_id => current_user.id).first
    
    @prev_user_month = Month.where(:month => @previousMonth, 
    							                 :year => @previousYear,
    							                 :user_id => current_user.id).first	
    
    @workouts = populate_workouts(@curr_user_month)
    @workout_length = @workouts.length

  end

  
  def populate_workouts(curr_month)
    workouts = []
    return nil if(curr_month == nil)  
    
    curr_month.days.each do |day|
      day.activities.each do |activity|
        workouts.push([activity.name, activity.duration, day.date])	
      end
    end
    return workouts
  end
  

end
