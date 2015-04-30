class Admin::AdminController < ApplicationController
  include DateFormat

  before_filter :check_logged_in, :check_admin, :force_password_change

  def sort(hash)
    case params[:sort]
      when "first_name"
        hash = hash.sort_by { |u, m| u.first_name.to_s }
        session[:sort] = params[:sort]
      when "last_name"
        hash = hash.sort_by { |u, m| u.last_name.to_s }
        session[:sort] = params[:sort]
      when "days"
        hash = hash.sort_by { |u, m| m.nil? ? 0 : m.get_num_approved_days.to_i }.reverse
        session[:sort] = params[:sort]
    end
    return hash
  end

  def get_date
    session[:months_ago].to_i.months.ago
  end

end
