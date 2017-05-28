Rails.application.routes.draw do

  # devise_for :users
  root :to => "admin/dashboard#index"
  # admin panel routes start
  namespace(:admin) do |admin|
    get '', to: 'dashboard#index'

    post 'login' => 'sessions#login'
    delete 'logout'=>'sessions#logout'

    resources :countries, except: [:new, :edit]

    get 'states/by_country', to: 'states#index_by_country'
    resources :states, except: [:index, :new, :edit]

    get 'cities/by_state', to: 'cities#index_by_state'
    resources :cities, except: [:index, :new, :edit]

    get 'main_categories/by_city', to: 'main_categories#index_by_city'
    resources :main_categories, except: [:index, :new, :edit]

    get 'sub_main_categories/by_main', to: 'sub_main_categories#index_by_main_category'
    resources :sub_main_categories, except: [:index, :new, :edit]

    get 'categories/by_sub', to: 'categories#index_by_sub_main_category'
    resources :categories, except: [:index, :new, :edit]
  end
  # admin panel routes end

end
