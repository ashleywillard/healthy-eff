require 'rails_helper'

RSpec.describe User, :type => :model do
  let(:dummy_class) { Class.new { extend ErrorMessages } }
  describe "user should not be able to create password" do
    it "with no uppercase character" do
      user = User.create(:email => "meow@meow.com", :password => '!fds3asdf', :password_confirmation => '!fds3asdf' )
      expect(user.errors.full_messages[0]).to eq("Password must include at least one uppercase character")
    end
    it "with no lowercase character" do
      user = User.create(:email => "meow@meow.com", :password => "!AFFE3ASDF", :password_confirmation => '!AFFE3ASDF')
      expect(user.errors.full_messages[0]).to eq("Password must include at least one lowercase character")
    end
    it "with no special character" do
      user = User.create(:email => "meow@meow.com", :password => "AFFfE3asdf", :password_confirmation => 'AFFfE3asdf')
      expect(user.errors.full_messages[0]).to eq("Password must include at least one special character")
    end
    it "with no number" do
      user = User.create(:email => "meow@meow.com", :password => "!ffFSDasdf", :password_confirmation => '!ffFSDasdf')
      expect(user.errors.full_messages[0]).to eq("Password must include at least one number")
    end
    it "with multiple errors" do
      user = User.create(:email => "meow@meow.com", :password => "lol", :password_confirmation => 'lol')
      expect(user.errors.full_messages).to include("Password is too short (minimum is 8 characters)")
      expect(user.errors.full_messages).to include(dummy_class.number_missing)
      expect(user.errors.full_messages).to include(dummy_class.uppercase_missing)
      expect(user.errors.full_messages).to include(dummy_class.special_missing)
    end
  end
end