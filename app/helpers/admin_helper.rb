module AdminHelper

  def future_records?
    @date > 0.months.ago
  end

  def beyond_earliest_records?
    earliest = Month.get_earliest_months() ; return true if earliest.nil?
    earliest = earliest.first
    return true if earliest.year.nil? or earliest.month.nil?
    earliest.year > @date.year or (earliest.year == @date.year and earliest.month > @date.month)
  end

  def no_records?
    @user_months.is_a?(Hash) and @user_months.values.all? { |m| m.nil? }
  end

  def get_record_as_date(day_num)
    Date.parse(day_num.to_s + "-" + @records.month.to_s + "-" + @records.year.to_s)
  end

end
