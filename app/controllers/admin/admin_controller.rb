class Admin::AdminController < ApplicationController
  include DateFormat

  before_filter :check_logged_in, :check_admin, :force_password_change

  def sort(h)
    case session[:sort]
      when "first_name"
        if h.is_a?(Hash)
          h = h.sort_by { |k, v| k.first_name.to_s }
        else
          h.sort_by! { |u| u.first_name.to_s }
        end
      when "last_name"
        if h.is_a?(Hash)
          h = h.sort_by {|k, v| k.last_name.to_s}
        else
          h.sort_by! { |u| u.last_name.to_s }
        end
      when "days"
        if h.is_a?(Hash)
          # sort by number of approved days, descending
          h = h.sort_by { |k, v| v.nil? ? 0 : v.get_num_approved_days().to_i }.reverse
        end
    end
    return h
  end

  def get_date
    session[:months_ago].to_i.months.ago
  end

end
