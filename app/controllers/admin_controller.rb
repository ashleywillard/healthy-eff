class AdminController < ApplicationController

  # either copy-paste the before_filter from ActivitiesController here to ensure
  # admin is logged in before executing any admin-related logic, or move the
  # before_filter function to ApplicationController, since you have to be logged
  # in to do basically anything for our app?

  # function to generate list of employees for the list view
  # RESTful: app.heroku.com/admin/list <-> employee_list_path
  def list
    # TO DO
  end

  # function to generate list of multiple-day activities for pending view
  # RESTful: app.heroku.com/admin/pending <-> pending_path
  def pending
    # TO DO
  end

  # potentially ashley/allan's stuff for adding and removing employees?
  # might also be in UsersController, depending on their implementation

end
