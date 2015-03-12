Rails.configuration.to_prepare do
  class SimpleCaptcha::SimpleCaptchaData < ::ActiveRecord::Base
    attr_protected
  end
end