require "rails_helper"
require File.expand_path("../../../users_helper", __FILE__)

RSpec.configure do |c|
  c.include UsersHelper
  c.include DateFormat
end

RSpec.describe Admin::PendingController do

  before :each do
    @user = mock_logged_in_admin()
    allow(controller).to receive(:current_user).and_return(@user)
    Constant.create! :curr_rate => 10
  end

  describe "admin/pending#update" do
    before :each do
      yesterday = Date.today.prev_day
      @month = Month.create_month_model(@user.id,
                                        get_month(yesterday),
                                        get_year(yesterday))
      @day1 = Day.create! :total_time => 60, :date => yesterday, :reason => "x",
                          :approved => false, :denied => false, :month_id => @month.id
      @day2 = Day.create! :total_time => 60, :date => yesterday, :reason => "x",
                          :approved => false, :denied => false, :month_id => @month.id
    end
    context "when no pending activities are checked" do
      before :each do
        allow(controller).to receive(:params).and_return({:selected => nil})
      end
      it "redirects to the current page" do
        put :update, :commit => "Approve"
        expect(response).to redirect_to admin_pending_path
        put :update, :commit => "Deny"
        expect(response).to redirect_to admin_pending_path
      end
    end
    context "when pending activities are checked" do
      context "when admin clicks 'Approve'" do
        before :each do
          allow(Day).to receive(:find).and_return(@day1)
        end
        it "approves the selected days" do
          expect(controller).to receive(:approve_or_deny).with(:approved)
          put :update, :commit => "Approve", :selected => [@day1.id.to_s]
        end
        it "displays a success message" do
          put :update, :commit => "Approve", :selected => [@day1.id.to_s]
          expect(flash[:notice]).to include("Success")
        end
      end
      context "when admin clicks 'Deny'" do
        before :each do
          allow(Day).to receive(:find).and_return(@day2)
        end
        it "denies the selected activities" do
          expect(controller).to receive(:approve_or_deny).with(:denied)
          put :update, :commit => "Deny", :selected => [@day2.id.to_s]
        end
        it "displays a success message" do
          put :update, :commit => "Deny", :selected => [@day2.id.to_s]
          expect(flash[:notice]).to include("Success")
        end
      end
    end
  end

end
