require "rails_helper"

RSpec.describe AdminController do

  SUCCESS_CODE = 200

  # mock a logged-in admin
  before :each do
    @user = double(User)
    @user.stub(:admin).and_return(true)
    allow_message_expectations_on_nil # suppress warnings on devise warden
    allow(request.env['warden']).to receive(:authenticate!).and_return(@user)
    allow(controller).to receive(:current_user).and_return(@user)
  end

  # check_logged_in behavior tested in activities_controller_spec

  describe "user.admin" do
    context "when admin" do
      it "allows access to the employee list page" do
        get :index
        expect(response.status).to eq(SUCCESS_CODE)
      end
    end
    context "when not admin" do
      before :each do
        # override default admin privilege
        @user.stub(:admin).and_return(false)
      end
      it "displays a 'forbidden' message on access attempts" do
        get :index
        expect(flash[:notice]).to eq("You don't have permission to access this.")
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
      @user_months = Month.create :month => Date.today.strftime("%m"),
                                  :year => Date.today.strftime("%Y")
      @prev_month = Month.create :month => (Date.today - 1.month).strftime("%m"),
                                 :year => Date.today.strftime("%Y")
      get :index
    end
    it "generates a list of user-associated months for current month" do
      expect(assigns(:user_months)).to eq([@user_months])
    end
  end

  describe "admin#pending" do
    context "when there are activities pending approval" do
      it "displays a list of pending activities"
    end
    context "when there are no activities pending approval" do
      it "displays a message notifying the admin of such"
      it "redirects to the list view"
    end
  end

  describe "admin#update_pending" do
    before :each do
      @day = double(Day).as_null_object
      @day.stub(:approved).and_return(false)
      @day.stub(:denied).and_return(false)
      @day.stub(:id).and_return(1)
      Day.stub(:find).and_return(@day)
    end
    context "when no pending activities are checked" do
      before :each do
        controller.stub(:params).and_return({:selected => nil})
      end
      it "redirects to the current page" do
        put :update_pending, :commit => "Approve"
        expect(response).to redirect_to admin_pending_path
        put :update_pending, :commit => "Deny"
        expect(response).to redirect_to admin_pending_path
      end
    end
    context "when pending activities are checked" do
      before :each do
        controller.stub(:params).and_return({:selected => ["1"]})
      end
      context "when admin clicks 'Approve'" do
        before :each do
          put :update_pending, :commit => "Approve"
        end
        it "approves the selected activities"
#         it "displays a success message" do
#           flash[:notice].should include("Success")
#         end
      end
      context "when admin clicks 'Deny'" do
        it "denies the selected activities"
#         it "displays a success message" do
#           flash[:notice].should include("Success")
#         end
      end
    end
  end

end
