class UsersController < ApplicationController

  def profile
  	@now = DateTime.now
  	@currentMonth = @now.strftime('%m').to_i
  	@previousMonth = @currentMonth-1 == 0 ? 12 : @currentMonth-1 
    @user_month = Month.where(:month => month_var, 
    							:year => year_var, 
    							:user_id => current_user.id)

    @events = []
    def populate_events 
	    user_month.days each |day| do
	    	day.activities each |day| do
	    		events.add(day.date, activity.activity, )	
    end
  end

end
