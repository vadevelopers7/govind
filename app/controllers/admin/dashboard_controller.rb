class Admin::DashboardController < ApplicationController
  def index
  	render '/admin_dashboard/logged_in', layout: false
  end
end
