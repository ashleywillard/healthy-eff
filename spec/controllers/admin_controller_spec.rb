require "rails_helper"

RSpec.describe AdminController do

  # this 'describe' is already covered in activities_controller_spec
    # cf. note in AdminController about maybe moving the filter to
    # ApplicationController; if that's the case, we'd write a separate RSpec for
    # ApplicationController and just shove this one in there
  describe "when not logged in" do
    it "redirects to the login page" do
      # pending
    end
    it "displays a not-logged-in message" do
      # pending
    end
  end

  describe "checks for admin privilege" do
    it "allows access if admin" do
      # pending
    end
    it "displays a 'forbidden' message if not admin" do
      # pending
    end
  end

  describe "admin#list" do
    it "provides a list of employee names" do
      # pending
    end
    it "provides the number of days each employee has done a healthy activity" do
      # pending
    end
  end

  describe "admin#pending" do
    it "displays a list of pending activities" do
      # pending
    end
  end

end
