require "rails_helper"

RSpec.describe AdminController do

  SUCCESS_CODE = 200

  # mock a logged-in admin
  before :each do
    @user = double(User)
    allow(@user).to receive(:admin).and_return(true)
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
        allow(@user).to receive(:admin).and_return(false)
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
    end
    it "generates a list of user-associated months for current month" do
      get :index
      expect(assigns(:user_months)).to eq([@user_months])
      expect([:user_months]).to_not include(@prev_month)
    end
  end

  describe "admin#pending" do
    context "when there are activities pending approval" do
      before :each do
        @day = Day.create :id => 1, :total_time => 60, :date => Date.today.prev_day,
                          :approved => false, :denied => false
        allow(Day).to receive(:where).and_return([@day])
      end
      it "renders a list of pending activities" do
        get :pending
        expect(response.status).to eq(SUCCESS_CODE)
      end
    end
    context "when there are no activities pending approval" do
      it "redirects to the list view" do
        get :pending
        expect(response).to redirect_to admin_list_path
      end
      it "displays a message notifying the admin of such" do
        get :pending
        expect(flash[:notice]).to_not eq(nil)
      end
    end
  end

  describe "admin#update_pending" do
    before :each do
      @day1 = Day.create! :total_time => 60, :date => Date.today.prev_day, :reason => "x",
                          :approved => false, :denied => false
      @day2 = Day.create! :total_time => 60, :date => Date.today.prev_day, :reason => "x",
                          :approved => false, :denied => false
    end
    context "when no pending activities are checked" do
      before :each do
        allow(controller).to receive(:params).and_return({:selected => nil})
      end
      it "redirects to the current page" do
        put :update_pending, :commit => "Approve"
        expect(response).to redirect_to admin_pending_path
        put :update_pending, :commit => "Deny"
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
          put :update_pending, :commit => "Approve", :selected => [@day1.id.to_s]
        end
        it "displays a success message" do
          put :update_pending, :commit => "Approve", :selected => [@day1.id.to_s]
          expect(flash[:notice]).to include("Success")
        end
      end
      context "when admin clicks 'Deny'" do
        before :each do
          allow(Day).to receive(:find).and_return(@day2)
        end
        it "denies the selected activities" do
          expect(controller).to receive(:approve_or_deny).with(:denied)
          put :update_pending, :commit => "Deny", :selected => [@day2.id.to_s]
        end
        it "displays a success message" do
          put :update_pending, :commit => "Deny", :selected => [@day2.id.to_s]
          expect(flash[:notice]).to include("Success")
        end
      end
    end
  end

end
