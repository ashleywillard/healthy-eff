class Admin::ListController < Admin::AdminController

  def index
    navigate_months()
    @date = get_date()
    @user_months = Hash.new
    User.includes(:months).all.each do |user|
      @user_months[user] = Month.get_month_model(user.id, get_month(@date), get_year(@date))
    end
    @user_months = sort(@user_months)
  end

  def navigate_months
    session[:months_ago] ||= 0
    case params[:navigate]
      when "Previous" then session[:months_ago] += 1
      when "Next" then session[:months_ago] -= 1
    end
  end

end
