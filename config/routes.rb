Rails.application.routes.draw do
  get 'admin_dashboard/index'

  root :to => "admin_dashboard#index"
end
