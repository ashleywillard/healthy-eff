require "rails_helper"

RSpec.describe ActivitiesController do
  describe "home page functionality" do
    it "displays the 'log activity for today' page if user is signed in"
    it "redirects to the login page if the user is not signed in"
  end
end
