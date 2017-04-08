Rails.application.routes.draw do

  root :to => "admin/dashboard#index"
  # admin panel routes start
  namespace(:admin) do |admin|
    get '', to: 'dashboard#index'

    resources :countries, except: [:new, :edit]

    get 'states/by_country', to: 'states#index_by_country'
    resources :states, except: [:index, :new, :edit]

    get 'cities/by_state', to: 'cities#index_by_state'
    resources :cities, except: [:index, :new, :edit]

    get 'categories/by_city', to: 'categories#index_by_city'
    resources :categories, except: [:index, :new, :edit]
  end
  # admin panel routes end

end
