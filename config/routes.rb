Rails.application.routes.draw do
  get 'admin_dashboard/index'

  root :to => "admin_dashboard#index"

  # admin panel routes start
  namespace(:admin) do |admin|
    resources :countries, except: [:new, :edit]
    resources :states, except: [:new, :edit]
  end
  # admin panel routes end

end
