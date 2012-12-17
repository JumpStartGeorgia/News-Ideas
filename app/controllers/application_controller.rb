class ApplicationController < ActionController::Base
	require 'will_paginate/array'
  protect_from_forgery

	before_filter :set_locale
#	before_filter :is_browser_supported?
	before_filter :load_categories
	before_filter :load_statuses
	before_filter :initialize_gon
	before_filter :initialize_new_idea
	after_filter :store_location

	layout :layout_by_resource

	unless Rails.application.config.consider_all_requests_local
		rescue_from Exception,
		            :with => :render_error
		rescue_from ActiveRecord::RecordNotFound,
		            :with => :render_not_found
		rescue_from ActionController::RoutingError,
		            :with => :render_not_found
		rescue_from ActionController::UnknownController,
		            :with => :render_not_found
		rescue_from ActionController::UnknownAction,
		            :with => :render_not_found

    rescue_from CanCan::AccessDenied do |exception|
      redirect_to root_url, :alert => exception.message
    end
	end

	protected

	Browser = Struct.new(:browser, :version)
	SUPPORTED_BROWSERS = [
		Browser.new("Chrome", "15.0"),
		Browser.new("Safari", "4.0.2"),
		Browser.new("Firefox", "10.0.2"),
		Browser.new("Internet Explorer", "9.0"),
		Browser.new("Opera", "11.0")
	]

	def is_browser_supported?
		user_agent = UserAgent.parse(request.user_agent)
logger.debug "////////////////////////// BROWSER = #{user_agent}"
		if SUPPORTED_BROWSERS.any? { |browser| user_agent < browser }
			# browser not supported
logger.debug "////////////////////////// BROWSER NOT SUPPORTED"
			render "layouts/unsupported_browser", :layout => false
		end
	end


	def set_locale
    if params[:locale] and I18n.available_locales.include?(params[:locale].to_sym)
      I18n.locale = params[:locale]
    else
      I18n.locale = I18n.default_locale
    end
	end

  def default_url_options(options={})
    { :locale => I18n.locale }
  end

	def initialize_gon
		gon.set = true
		gon.highlight_first_form_field = true
		gon.placeholder = t('app.common.placeholder')
		gon.comment_notification_url = comment_notification_path(gon.placeholder)
		gon.fb_app_id = ENV['NEWS_IDEAS_FACEBOOK_APP_ID']
		gon.id_top = t('app.common.top_ideas').gsub(" ", "_").downcase
		gon.id_new = t('app.common.new_ideas').gsub(" ", "_").downcase
		gon.id_in_progress = t('app.common.in_progress').gsub(" ", "_").downcase
		gon.id_realized = t('app.common.realized').gsub(" ", "_").downcase
		@id_top = gon.id_top
		@id_new = gon.id_new
		@id_in_progress = gon.id_in_progress
		@id_realized = gon.id_realized

		gon.idea_status_id_published = @idea_statuses.select{|x| x.is_published}.first.id.to_s
	end

	def load_categories
		@categories = Category.with_translations(I18n.locale).sorted_by_name
	end

	def load_statuses
		@idea_statuses = IdeaStatus.with_translations(I18n.locale).sorted
	end

	def initialize_new_idea
    @idea = Idea.new
		@idea.idea_categories.build
	end

	# after user logs in, go to admin page
	def after_sign_in_path_for(resource)
		request.env['omniauth.origin'] || session[:previous_urls].last || root_path
	end

	# store the current path so after login, can go back
	def store_location
		session[:previous_urls] ||= []
		# only record path if page is not for users (sign in, sign up, etc) and not for reporting problems
		if session[:previous_urls].first != request.fullpath && request.fullpath.index("/users/").nil? && request.fullpath.index("/report/").nil?
			session[:previous_urls].unshift request.fullpath
		end
		session[:previous_urls].pop if session[:previous_urls].count > 1
	end

  def valid_role?(role)
    redirect_to root_path, :notice => t('app.msgs.not_authorized') if !current_user || !current_user.role?(role)
  end

	DEVISE_CONTROLLERS = ['devise/sessions', 'devise/registrations', 'devise/passwords']
	def layout_by_resource
    if DEVISE_CONTROLLERS.index(params[:controller]).nil?
      "application"
    else
      "fancybox"
    end
  end

  #######################
	def render_not_found(exception)
		ExceptionNotifier::Notifier
		  .exception_notification(request.env, exception)
		  .deliver
		render :file => "#{Rails.root}/public/404.html", :status => 404
	end

	def render_error(exception)
		ExceptionNotifier::Notifier
		  .exception_notification(request.env, exception)
		  .deliver
		render :file => "#{Rails.root}/public/500.html", :status => 500
	end



end
