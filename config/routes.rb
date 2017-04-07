Rails.application.routes.draw do

  root :to => "admin_dashboard#index"
  get 'admin_dashboard/index'

  # admin panel routes start
  namespace(:admin) do |admin|
    resources :countries, except: [:new, :edit]
    
    get 'states/by_country', to: 'states#index_by_country'
    resources :states, except: [:index, :new, :edit]
  end
  # admin panel routes end

end
