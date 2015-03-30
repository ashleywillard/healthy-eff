class UsersController < ApplicationController

  def profile
  	@now = Time.now
  	@currentMonth = @now.month
  	@previousMonth = @currentMonth-1 == 0 ? 12 : @currentMonth-1 
    
  end

end
