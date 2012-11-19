BootstrapStarter::Application.routes.draw do
	#--------------------------------
	# all resources should be within the scope block below
	#--------------------------------
	scope ":locale", locale: /#{I18n.available_locales.join("|")}/ do

		match '/admin', :to => 'admin#index', :as => :admin, :via => :get
		devise_for :users
		namespace :admin do
			resources :users
			resources :organizations
			resources :categories
		end

		match '/idea/:id', :to => 'root#idea', :as => :idea, :via => :get
		match '/explore/:id', :to => 'root#explore', :as => :explore, :via => :get
		match '/category/:id', :to => 'root#category', :as => :category, :via => :get
		match '/create', :to => 'root#create', :as => :create_idea, :via => :post
		match '/vote/:type/:votable_id/:status', :to => 'root#vote', :as => :vote, :via => :get

		root :to => 'root#index'
	  match "*path", :to => redirect("/#{I18n.locale}") # handles /en/fake/path/whatever
	end

	match '', :to => redirect("/#{I18n.default_locale}") # handles /
	match '*path', :to => redirect("/#{I18n.default_locale}/%{path}") # handles /not-a-locale/anything

end
