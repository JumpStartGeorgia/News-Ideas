BootstrapStarter::Application.routes.draw do
	#--------------------------------
	# all resources should be within the scope block below
	#--------------------------------
	scope ":locale", locale: /#{I18n.available_locales.join("|")}/ do

		devise_for :users, :path_names => {:sign_in => 'login', :sign_out => 'logout'},
											 :controllers => {:omniauth_callbacks => "omniauth_callbacks"}

		match '/admin', :to => 'admin#index', :as => :admin, :via => :get
		namespace :admin do
			resources :users
			resources :organizations
			resources :categories
		end

		match '/idea/:id', :to => 'root#idea', :as => :idea, :via => :get
		match '/explore/:id', :to => 'root#explore', :as => :explore, :via => :get
		match '/category/:id', :to => 'root#category', :as => :category, :via => :get
		match '/user/:id', :to => 'root#user', :as => :user, :via => :get
		match '/organization/:id', :to => 'root#organization', :as => :organization, :via => :get
		match '/create', :to => 'root#create', :as => :create_idea, :via => :post
		match '/search', :to => 'root#search', :as => :search, :via => :get
		match '/search', :to => 'root#search', :as => :search, :via => :post
		match '/vote/:type/:votable_id/:status', :to => 'root#vote', :as => :vote, :via => :get

		# progress
		match '/progress/claim/:idea_id/:organization_id', :to => 'progress#claim', :as => :claim_idea, :via => :get
		match '/progress/progress_update/:idea_id/:organization_id', :to => 'progress#progress_update', :as => :progress_update, :via => :get
		match '/progress/save', :to => 'progress#save', :as => :save_progress, :via => :post


		root :to => 'root#index'
	  match "*path", :to => redirect("/#{I18n.locale}") # handles /en/fake/path/whatever
	end

	match '', :to => redirect("/#{I18n.default_locale}") # handles /
	match '*path', :to => redirect("/#{I18n.default_locale}/%{path}") # handles /not-a-locale/anything

end
