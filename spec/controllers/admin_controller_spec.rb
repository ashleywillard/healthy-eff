require "rails_helper"

RSpec.describe AdminController do

  # mock a logged-in user
  before :each do
    @user = double('@user')
    allow(request.env['warden']).to receive(:authenticate!).and_return(@user)
    allow(controller).to receive(:current_user).and_return(@user)
  end

  # check_logged_in behavior tested in activities_controller_spec

  describe "user.admin" do
    context "when admin" do
      before :each do
        @user.stub(:admin).and_return(true)
      end
      it "allows access to the employee list page" do
        get :index
        expect(response.status).to eq(200)
      end
    end
    context "when not admin" do
      before :each do
        @user.stub(:admin).and_return(false)
      end
      it "displays a 'forbidden' message on access attempts" do
        get :index
        flash[:notice].should eq("You don't have permission to access this.")
      end
      it "redirects to the root page on access attempts" do
        get :index
        expect(response).to redirect_to(today_path)
        get :pending
        expect(response).to redirect_to(today_path)
      end
    end
  end

  describe "admin#index" do
    before :each do
      @user.stub(:admin).and_return(true)
    end
    it "displays a list of employee names"
    it "provides the number of days each employee has done a healthy activity"
  end

  describe "admin#pending" do
    before :each do
      @user.stub(:admin).and_return(true)
    end
    context "when there are activities pending approval" do
      it "displays a list of pending activities"
    end
    context "when there are no activities pending approval" do
      it "displays a message notifying the admin of such"
      it "redirects to the list view"
    end
  end

  describe "admin#update_pending" do
    context "when no pending activities are checked" do
      it "redirects to the current page"
    end
    context "when pending activities are checked" do
      context "when admin clicks 'Approve'" do
        it "approves the selected activities"
        it "displays a success message"
      end
      context "when admin clicks 'Deny'" do
        it "denies the selected activities"
        it "displays a success message"
      end
    end
  end

end
