class Admin::DashboardController < ApplicationController
  def index
  	render '/admin/logged_in', layout: false
  end
end
