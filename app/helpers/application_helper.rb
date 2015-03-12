module ApplicationHelper
  def link_to_add_activity(name)
    fields = fields_for :activites do |builder|
      render :partial => 'activity_fields'
    end
    link_to_function name, "add_fields(this, \":activities\", \"#{escape_javascript(fields)}\")"
  end

  def link_to_add_day(name)
    fields = fields_for :days do |builder|
      render :partial => 'day_fields'
    end
    link_to_function name, "add_fields(this,  \":days\", \"#{escape_javascript(fields)}\")"
  end
end
