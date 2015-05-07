module DateFormat
  def format_date(date)
    return date.strftime("%m/%d/%Y")
  end

  def get_month(date)
    return date.strftime("%m").to_i
  end

  def get_month_name(date)
    return date.strftime("%B")
  end

  def get_year(date)
    return date.strftime("%Y").to_i
  end

  def get_day(date)
    return date.strftime("%d").to_i
  end

  def get_today(timezone="Pacific Time (US & Canada)")
    #Should only call this to get local time
    timezone = "Pacific Time (US & Canada)" if timezone == "" || timezone == nil
    return Time.now.utc.to_datetime.in_time_zone(timezone).to_date
  end
end
