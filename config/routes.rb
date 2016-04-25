Rails.application.routes.draw do
  
  get '/AmerickazMostWanted' => "home#gangsta_party", as: :americkaz_most
  get '/AmerickazMostWanted_prep' => "home#gangsta_party_prep", as: :americkaz_most_prep

  get '/TodayWasAGoodDay' => "home#good_day", as: :good_day
  get '/TodayWasAGoodDay_prep' => "home#good_day_prep", as: :good_day_prep

  get '/GangstasParadise' => "home#gangsta_paradise", as: :paradise
  get '/GangstasParadise_prep' => 'home#gangsta_paradise_prep', as: :paradise_prep
  
  get '/Juicy_prep' => "home#juicy_prep", as: :juicy_prep
  get '/Juicy' => "home#juicy", as: :juicy

  get '/LoseYourself_prep' => "home#lose_yourself_prep", as: :lose_yourself_prep
  get '/LoseYourself' => "home#lose_yourself", as: :lose_yourself

  root 'home#index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
