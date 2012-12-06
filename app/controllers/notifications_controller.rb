class NotificationsController < ApplicationController
  before_filter :authenticate_user!

	def index
		gon.notifications = true

		if request.post?
			if params[:none]
				# delete all notifications
				Notification.where(:notification_type => Notification::TYPES[:new_idea],
																				:user_id => current_user.id).delete_all
				flash[:notice] = I18n.t('.none_success')
			elsif params[:all]
				# all notifications
				# delete anything on file first
				Notification.where(:notification_type => Notification::TYPES[:new_idea],
																				:user_id => current_user.id).delete_all
				# add all option
				Notification.create(:notification_type => Notification::TYPES[:new_idea],
																				:user_id => current_user.id)

				flash[:notice] = I18n.t('.all_success')
			elsif params[:categories] && !params[:categories].empty?
				# by category
				# delete anything on file first
				Notification.where(:notification_type => Notification::TYPES[:new_idea],
																				:user_id => current_user.id).delete_all
				# add each category
				params[:categories].each do |cat_id|
					Notification.create(:notification_type => Notification::TYPES[:new_idea],
																					:user_id => current_user.id,
																					:identifier => cat_id)
				end
				flash[:notice] = I18n.t('.by_category_success',
					:categories => @categories.select{|x| params[:categories].index(x.id.to_s)}.map{|x| x.name}.join(","))

			end
		end

		# get data to load the form
		@notifications = Notification.where(:notification_type => Notification::TYPES[:new_idea],
																			:user_id => current_user.id)

		@all = false
		@none = false

		if @notifications && !@notifications.empty?
			if @notifications.length == 1 && @notifications.first.identifier.nil?
				@all = true
			end
		else
			@none = true
		end
	end

end
