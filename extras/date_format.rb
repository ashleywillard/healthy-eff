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
end
