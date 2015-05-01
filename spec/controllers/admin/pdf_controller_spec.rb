require "rails_helper"
require File.expand_path("../../../users_helper", __FILE__)

RSpec.configure do |c|
  c.include UsersHelper
end

RSpec.describe Admin::PdfController do

  before :each do
    @user = mock_logged_in_admin()
    allow(controller).to receive(:current_user).and_return(@user)
    Constant.create! :curr_rate => 10
  end

  describe "admin/pdf#audit" do
    it "makes a call to generate a printable PDF document" do
      expect(controller).to receive(:generate_pdf)
      get :audit, :month => Date.today.month, :year => Date.today.year, :id => 1
    end
  end

  describe "admin/pdf#accounting" do
    context "when the user has not logged anything this month" do
      before :each do
        allow(Month).to receive(:get_month_model).and_return(nil)
        allow(@user).to receive(:first_name).and_return("first")
        allow(@user).to receive(:last_name).and_return("last")
        allow(User).to receive(:find_by_id).and_return(@user)
      end
      it "redirects to the list view" do
        get :accounting, :month => Date.today.month, :year => Date.today.year, :id => 1
        expect(response).to redirect_to :controller => 'admin/list',
                                        :action => :index
      end
      it "does not generate a PDF" do
        get :accounting, :month => Date.today.month, :year => Date.today.year, :id => 1
        expect(controller).to receive(:generate_pdf).exactly(0).times
      end
    end
    context "when users have logged activities this month" do
      before :each do
        allow(@user).to receive(:id).and_return(1)
        allow(@user).to receive(:first_name).and_return("first")
        allow(@user).to receive(:last_name).and_return("first")
        allow(User).to receive(:find_by_id).and_return(@user)
        @month = double(Month)
        allow(@month).to receive(:user).and_return(@user)
        allow(Month).to receive(:find_by_id).and_return(@month)
        Month.any_instance.stub(:get_num_approved_days).and_return(2)
      end
      it "makes a call to generate a printable PDF document" do
        expect(controller).to receive(:generate_pdf).exactly(1).times
        get :accounting, :month => Date.today.month, :year => Date.today.year, :id => @user.id, :selected => ["1"]
      end
      it "does not generate a PDF when no employees are checked" do
        expect(controller).to receive(:generate_pdf).exactly(0).times
        get :accounting, :month => Date.today.month, :year => Date.today.year, :id => @user.id
      end
    end
  end

  describe "admin/pdf#mark_form_received" do
    context "when users are checked" do
      it "updates the received_form? column of the Month table" do
        allow(@user).to receive(:last_name).and_return("last")
        month = Month.create_month_model(@user.id, Date.today.strftime("%m"), Date.today.strftime("%Y"))
        allow(Month).to receive(:find_by_id).and_return(month)
        post :forms, :commit => "Mark Received", :selected => { @user.last_name => month.id },
                     :year => Date.today.year, :month => Date.today.month
        expect(month.received_form).to eq(true)
      end
    end
    context "when no users are checked" do
      it "makes no calls to the database" do
        expect(Month).to receive(:find).exactly(0).times
        expect(User).to receive(:find).exactly(0).times
      end
      it "redirects to the list view" do
        post :forms
        expect(response).to redirect_to :controller => 'admin/list',
                                        :action => :index
      end
    end
  end

end
