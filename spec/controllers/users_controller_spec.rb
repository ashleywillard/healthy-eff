require "rails_helper"

RSpec.describe UsersController do

  describe "When at my profile page" do
    it "retrieves workouts for this and previous months" do
      get :profile
    end
    it "retrieves workouts even when user has not worked out for this or previous months" do
      get :profile
    end
    it "marks denied workouts as red" do
      get :profile
    end
    it "marks pending workouts as yellow" do
      get :profile
    end
    it "marks approved workouts as green" do
      get :profile
    end

  end