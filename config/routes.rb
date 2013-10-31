Rails.application.routes.draw do

  # The priority is based upon order of creation:
  # first created -> highest priority.



  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'



  # Keep in mind you can assign values other than :controller and :action
  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)



  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products


  root :to => 'users#home'

  match 'translations/index', :to => 'translations#index', :as => 'locales_path', :via => :get

  match 'translations/:id', :to => 'translations#update', :via => :put

  match 'translations/:id', :to => 'translations#destroy', :via => :delete

  match 'translations/generate_pos', :to => 'translations#generate_pos', :via => :post

  match 'translations/generation_status', :to => 'translations#generation_status', :via => :get

  match 'translations/upload_po', :to => 'translations#upload_po'

  match 'translations/get_po/:locale', :to => 'translations#get_po', :via => :get

  match 'translations/delete_po/:locale', :to => 'translations#delete_po', :via => :delete


  # This is a legacy wild controller route that's not recommended for RESTful applications.  Note: This route will make all actions in every controller accessible via GET requests.

  match ':controller(/:action(/:id))(.:format)'

end
