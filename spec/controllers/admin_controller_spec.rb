require "rails_helper"

RSpec.describe AdminController do

  # check_logged_in behavior tested in activities_controller_spec

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
