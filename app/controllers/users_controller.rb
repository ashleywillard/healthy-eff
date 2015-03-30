class UsersController < ApplicationController

  def profile
  	@now = DateTime.now
  	@currentMonth = @now.strftime('%m').to_i
  	@previousMonth = @currentMonth-1 == 0 ? 12 : @currentMonth-1 
    #@calendarInfo=User.Month.Day.Activity.where(:user_id => current_user,
    											#:month => @currentMonth,
    											#:year => @now.year)
  end

end
