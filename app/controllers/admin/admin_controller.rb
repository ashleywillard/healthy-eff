class Admin::AdminController < ApplicationController
  include DateFormat

  before_filter :check_logged_in, :check_admin, :force_password_change

  def sort(hash)
    case session[:sort]
      when "first_name"
        hash = hash.sort_by {|k, v| k.first_name.to_s}
      when "last_name"
        hash = hash.sort_by {|k, v| k.last_name.to_s}
      when "days"
        hash = hash.sort_by {|k, v| v.nil? ? 0 : v.get_num_approved_days().to_i}.reverse
    end
    return hash
  end

  def get_date
    session[:months_ago].to_i.months.ago
  end

end
