module ApplicationHelper
  def link_to_add_activity(name)
    fields = fields_for :activites do |builder|
      render :partial => 'activity_fields'
    end
    link_to(name, '#', class: "add_fields", data: {fields: fields.gsub("\n", "")})
  end
  
  def link_to_add_day(name)
    fields = fields_for :days do |builder|
      render :partial => 'day_fields'
    end
    link_to(name, '#', class: "add_fields", data: {fields: fields.gsub("\n", "")})
  end
end
