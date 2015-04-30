require "rails_helper"
require File.expand_path("../../../users_helper", __FILE__)

RSpec.configure do |c|
  c.include UsersHelper
end

RSpec.describe Admin::ListController do

  before :each do
    @user = mock_logged_in_admin()
    allow(controller).to receive(:current_user).and_return(@user)
    Constant.create! :curr_rate => 10
  end

  describe "user.admin" do
    SUCCESS_CODE ||= 200
    context "when admin" do
      it "allows access to the employee list page" do
        get :index
        expect(response.status).to eq(SUCCESS_CODE)
      end
    end
    context "when not admin" do
      before :each do
        # override default admin privilege
        allow(@user).to receive(:admin).and_return(false)
      end
      it "displays a 'forbidden' message on access attempts" do
        extend ErrorMessages
        get :index
        expect(flash[:alert]).to eq(deny_access("index"))
      end
      it "redirects to the root page on access attempts" do
        get :index
        expect(response).to redirect_to(today_path)
        get :index, :controller => 'admin/pending'
        expect(response).to redirect_to(today_path)
      end
    end
  end

  describe "admin/list#index" do
    before :each do
      @user = User.create! :email => 'testuser@test.com',
                           :password => '?1234Abcedfg',
                           :password_confirmation => '?1234Abcedfg'
      @cur_month = Month.create_month_model(@user.id, Date.today.strftime("%m"), Date.today.strftime("%Y"))
      Day.create! :date => Date.today - 1.day,
                  :approved => true,
                  :total_time => 60,
                  :reason => 'Reason',
                  :month_id => @cur_month.id
      @prev_month = Month.create_month_model(@user.id, (Date.today - 1.month).strftime("%m"), Date.today.strftime("%Y"))
    end
    it "generates a list of user-associated months for current month" do
      get :index
      expect(assigns(:user_months)).to eq({@user => @cur_month})
      expect([:user_months]).to_not include(@prev_month)
    end
  end

  describe "admin/list#navigate_months" do
    before :each do
      @user = User.create! :email => 'testuser@test.com',
                           :password => '?1234Abcedfg',
                           :password_confirmation => '?1234Abcedfg'
      @cur_month = Month.create_month_model(@user.id, Date.today.strftime("%m"), Date.today.strftime("%Y"))
      Day.create! :date => Date.today - 1.day,
                  :approved => true,
                  :total_time => 60,
                  :reason => 'Reason',
                  :month_id => @cur_month.id
      @prev_month = Month.create_month_model(@user.id, (Date.today - 1.month).strftime("%m"), Date.today.strftime("%Y"))
    end
    it "stores the month being viewed in the session hash" do
      get :index
      expect(session[:months_ago]).to_not eq(nil)
    end
    it "allows the admin to view records for the previous month" do
      get :index, :navigate => "Previous"
      expect(session[:months_ago]).to be > 0
    end
  end

  describe "admin/list#sort" do
    it "makes no additional queries to the database" do
      expect(Month).to receive(:find).exactly(0).times
      expect(User).to receive(:find).exactly(0).times
    end
    it "updates the session hash" do
      get :index, :sort => "last_name"
      expect(session[:sort]).to_not eq(nil)
    end
    it "guards against bogus sorting params" do
      expect { get :index, :sort => "blah" }.to_not raise_error
    end
  end

end
