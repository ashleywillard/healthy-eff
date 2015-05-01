class Admin::PdfController < Admin::AdminController

  # direct to correct form generator logic
  def forms
    redirect_to admin_list_path and return if params[:selected].nil?
    case params[:commit]
      when "Print Selected" then accounting()
      when "Mark Received" then mark_form_received()
      else redirect_to admin_list_path
    end
  end

  # mark an employee's accounting form as received
  def mark_form_received
    @date = get_date()
    params[:selected].each do |last_name, month_id|
      month = Month.find_by_id(month_id)
      month.received_form = true
      month.save
    end
    flash[:notice] = RECEIVED_FORM
    redirect_to admin_list_path
  end

  # ===== AUDIT ===== #

  # monthly audit form
  def audit
    @date = get_date()
    @user_months = []
    User.includes(:months).all.each do |user|
      @user_months << Month.get_or_create_month_model(user.id, get_month(@date), get_year(@date))
    end
    @user_months = @user_months.sort_by { |m| m.user.last_name.to_s }
    html = render_to_string(:layout => false, :action => 'audit')
    generate_pdf("audit", "audit-#{get_month_name(@date)}-#{get_year(@date)}.pdf", html)
  end

  # ===== ACCOUNTING ===== #

  # accounting forms
  def accounting
    redirect_to admin_list_path and return if params[:selected].nil?
    @date = get_date()
    @num_days = Time.days_in_month(@date.month, @date.year)
    name_accounting_forms(render_accounting_html())
  end

  # provide informative names for accounting PDFs
  def name_accounting_forms(html)
    if params[:selected].length == 1
      pdf_name = "acct-#{@user.last_name}-#{get_month_name(@date)}-#{get_year(@date)}.pdf"
    else
      pdf_name = "acct-#{get_month_name(@date)}-#{get_year(@date)}.pdf"
    end
    generate_pdf("accounting", pdf_name, html)
  end

  # add each selected employee's accounting form to the PDF; produce single file
  def render_accounting_html
    @first = true
    html = ''
    params[:selected].each do |m_id|
      @first = false if m_id == params[:selected][1] # insert page breaks
      next if Month.find_by_id(m_id).nil?
      generate_accounting_sheet(m_id)
      html << render_to_string(:layout => false, :action => 'accounting')
    end
    return html
  end

  # set up instance variables for use in the PDF views
  def generate_accounting_sheet(month_id)
    @user = Month.find_by_id(month_id).user
    @records = Month.get_month_model(@user.id, @date.month, @date.year)
    @records.nil? ? @user_days = 0 : @user_days = @records.get_num_approved_days()
  end

  # ===== GENERAL PDF LOGIC ===== #

  def generate_pdf(type, name, html)
    case type
      when 'audit'
        orientation = 'Landscape'
      when 'accounting'
        orientation = 'Portrait'
    end
    kit = PDFKit.new(html, :orientation => orientation)
    kit.stylesheets << "#{Rails.root}/app/assets/stylesheets/pdf.css"
    send_data(kit.to_pdf, :filename => name,
                          :type => 'application/pdf',
                          :disposition => "inline")
  end

end
