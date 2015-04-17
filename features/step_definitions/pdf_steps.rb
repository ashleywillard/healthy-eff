module PDF
  class PdfToText
    def initialize(pdf_file)
      @receiver = PDF::SimplePageTextReceiver.new
      pdf = PDF::Reader.file(pdf_file, @receiver)
    end
 
    def get_text
      @receiver.content.inspect
    end
  end
end

module PDF
  class SimplePageTextReceiver
    attr_accessor :content
 
    def initialize
      @content = []
    end
 
    # Called when page parsing starts
    def begin_page(arg = nil)
      @content << ""
    end
 
    # record text that is drawn on the page
    def show_text(string, *params)
      @content.last << string.strip
    end
 
    # there's a few text callbacks, so make sure we process them all
    alias :super_show_text :show_text
    alias :move_to_next_line_and_show_text :show_text
    alias :set_spacing_next_line_show_text :show_text
 
    # this final text callback takes slightly different arguments
    def show_text_with_positioning(*params)
      params = params.first
      params.each { |str| show_text(str) if str.kind_of?(String)}
    end
  end
end


When(/^I follow the PDF button "([^"]+)"$/) do |label|
  click_button(label)
  temp_pdf = Tempfile.new('pdf')
  temp_pdf << page.source.force_encoding('UTF-8')
  temp_pdf.close
  @pdf_text = PDF::PdfToText.new(temp_pdf.path)
  page.driver.response.instance_variable_set('@body', @pdf_text.get_text)
end

Then(/^the following names should be listed on the audit form: "(.*)"$/) do |last|
	assert_not_equal(page.driver.response.instance_variable_get('@body').index(/#{last}/), nil)
end




