Rails.application.routes.draw do

  root :to => "admin/admin_dashboard#index"
  # admin panel routes start
  namespace(:admin) do |admin|
    get '', to: 'admin_dashboard#index'

    resources :countries, except: [:new, :edit]

    resources :states, except: [:index, :new, :edit]
    get 'states/by_country', to: 'states#index_by_country'

    resources :cities, except: [:index, :new, :edit]
    get 'cities/by_state', to: 'cities#index_by_state'
  end
  # admin panel routes end

end
