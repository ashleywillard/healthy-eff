class AdminController < ApplicationController

  # either copy-paste the before_filter from ActivitiesController here to ensure
  # admin is logged in before executing any admin-related logic, or move the
  # before_filter function to ApplicationController, since you have to be logged
  # in to do basically anything for our app?

  # function to generate list of employees for the list view
    # RESTful: app.heroku.com/admin/list/:month <-> employee_list_path
  def list
    # TO DO
  end

  # function to generate PDF printout for a single employee (accounting sheet)
    # (?) RESTful: app.heroku.com/admin/accounting/:month/:id (?)
  # NOT YET IMPLEMENTED

  # function to generate PDF printout for all employees (audit sheet)
    # (?) RESTful: app.heroku.com/admin/audit/:month (?)
  # NOT YET IMPLEMENTED

  # function to generate list of multiple-day activities for pending view
    # RESTful: app.heroku.com/admin/pending <-> pending_path
  def pending
    # TO DO
  end

  # function to approve a single pending activity
  def approve
    # TO DO
    # display a flash message and redirect back to pending page?
  end

  # potentially ashley/allan's stuff for adding and removing employees?
  # might also be in UsersController, depending on their implementation

end
