require "rails_helper"

RSpec.describe AdminController do

  before :each do
      @user = double('@user')
      allow(request.env['warden']).to receive(:authenticate!).and_return(@user)
      allow(controller).to receive(:current_user).and_return(@user)
  end

  # check_logged_in behavior tested in activities_controller_spec

  describe "when user is an admin" do
    before :each do
      @user.stub(:admin).and_return(true)
    end
    it "allows access to the employee list page" do
      get :index
      expect(response.status).to eq(200)
    end
    it "allows access to the pending approval page" do
      get :pending
      expect(response.status).to eq(200)
    end
  end

  describe "when user is not an admin" do
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

  describe "admin#index" do
    before :each do
      @user.stub(:admin).and_return(true)
    end
    it "renders a list of employee names" do
      pending
    end
    it "provides the number of days each employee has done a healthy activity" do
      pending
    end
  end

  describe "admin#pending" do
    before :each do
      @user.stub(:admin).and_return(true)
    end
    it "displays a list of pending activities" do
      pending
    end
  end

end
