module AdminHelper
  def future_records?
    @date > 0.months.ago
  end

  def beyond_earliest_records?
    earliest = Month.get_earliest_months().first
    earliest.year > @date.year or (earliest.year == @date.year and earliest.month > @date.month)
  end
end
