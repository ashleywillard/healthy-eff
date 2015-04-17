require "rails_helper"

RSpec.describe AdminController do

  SUCCESS_CODE = 200
  REDIRECT_CODE = 302

  # mock a logged-in admin
  before :each do
    @user = double(User)
    allow(@user).to receive(:id).and_return(1)
    allow(@user).to receive(:admin).and_return(true)
    allow(@user).to receive(:password_changed?).and_return(true)
    allow_message_expectations_on_nil # suppress warnings on devise warden
    allow(request.env['warden']).to receive(:authenticate!).and_return(@user)
    allow(controller).to receive(:current_user).and_return(@user)
  end

  # check_logged_in behavior tested in days_controller_spec

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
      Day.create! :date => Date.today - 1.day,
                  :approved => true,
                  :total_time => 60,
                  :reason => 'Reason',
                  :month_id => @user_months.id
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
      yesterday = Date.today.prev_day
      @month = Month.create! :month => DateFormat.get_month(yesterday),
                            :year => DateFormat.get_year(yesterday),
                            :num_of_days => 0
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

  describe "admin#audit" do
    it "makes a call to generate a printable PDF document" do
      expect(controller).to receive(:generate_pdf)
      get :audit, :month => Date.today.month, :year => Date.today.year, :id => 1
    end
  end

  describe "admin#accounting" do
    context "when the user has not logged anything this month" do
      before :each do
        allow(Month).to receive(:get_month_model).and_return(nil)
        allow(@user).to receive(:first_name).and_return("first")
        allow(@user).to receive(:last_name).and_return("last")
        allow(User).to receive(:find_by_id).and_return(@user)
      end
      it "redirects to the list view when the user hasn't logged anything" do
        get :accounting, :month => Date.today.month, :year => Date.today.year, :id => 1
        expect(response.status).to eq(REDIRECT_CODE)
      end
      it "displays a message notifying the admin of such" do
        get :accounting, :month => Date.today.month, :year => Date.today.year, :id => 1
        expect(flash[:notice]).to_not eq(nil)
      end
    end
    context "when users have logged activities this month" do
      it "makes a call to generate a printable PDF document" do
        allow(@user).to receive(:id).and_return(1)
        allow(@user).to receive(:first_name).and_return("first")
        allow(@user).to receive(:last_name).and_return("first")
        allow(User).to receive(:find_by_id).and_return(@user)
        Month.any_instance.stub(:get_num_approved_days).and_return(2)
        expect(controller).to receive(:generate_pdf)
        get :accounting, :month => Date.today.month, :year => Date.today.year, :id => @user.id
      end
    end
  end

  describe "admin#group_accounting" do
    it "does not generate a PDF when no employees are checked" do
      get :group_accounting
      expect(controller).to_not receive(:generate_pdf)
    end
    it "bounces PDF request to normal 'accounting()' when only one user checked" do
      allow(@user).to receive(:id).and_return(1)
      allow(User).to receive(:find_by_id).and_return(@user)
      @month = double(Month)
      allow(@month).to receive(:user).and_return(@user)
      allow(Month).to receive(:find_by_id).and_return(@month)
      expect(controller).to receive(:accounting)
      get :group_accounting, :selected => ["1"]
    end
  end

  describe "admin#navigate_months" do
    it "stores the month being viewed in the session hash" do
      get :index
      expect(session[:months_ago]).to_not eq(nil)
    end
  end

  describe "admin#sort" do
    it "makes no additional queries to the database" do
      expect(Month).to receive(:find).exactly(0).times
      expect(User).to receive(:find).exactly(0).times
    end
    it "updates the session hash" do
      get :index, :sort => "last_name"
      expect(session[:sort]).to_not eq(nil)
    end
  end

end
