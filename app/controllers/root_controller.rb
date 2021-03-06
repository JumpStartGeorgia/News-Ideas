class RootController < ApplicationController

  def index
    respond_to do |format|
      format.html {
				new_ideas = Idea.with_private(current_user).new_ideas.appropriate#.paginate(:page => params[:page])
				top_ideas = Idea.with_private(current_user).top_ideas.appropriate#.paginate(:page => params[:page])
				in_progress_ideas = Idea.with_private(current_user).in_progress_ideas(current_user).appropriate#.paginate(:page => params[:page])
				realized_ideas = Idea.with_private(current_user).realized_ideas(current_user).appropriate#.paginate(:page => params[:page])
				@ideas = {:new => new_ideas, :top => top_ideas, :in_progress => in_progress_ideas, :realized => realized_ideas}
				render :layout => 'application_home'
      }
      format.js {
				# test which tab to get data for
				@ideas = nil
				case params[:tab]
					when @id_new
						@ideas = Idea.with_private(current_user).new_ideas.appropriate#.paginate(:page => params[:page])
					when @id_top
						@ideas = Idea.with_private(current_user).top_ideas.appropriate#.paginate(:page => params[:page])
					when @id_in_progress
						@ideas = Idea.with_private(current_user).in_progress_ideas(current_user).appropriate#.paginate(:page => params[:page])
					when @id_realized
						@ideas = Idea.with_private(current_user).realized_ideas(current_user).appropriate#.paginate(:page => params[:page])
				end
			}
    end


  end

	def explore
		@explore = params[:id].humanize
		@initial_tab_id = case params[:id]
			when 'top'
				gon.id_top
			when 'new'
				gon.id_new
			when 'in_progress'
				gon.id_in_progress
			when 'realized'
				gon.id_realized
		end
		gon.initial_tab_id = @initial_tab_id

		new_ideas = Idea.with_private(current_user).new_ideas.appropriate#.paginate(:page => params[:page])
		top_ideas = Idea.with_private(current_user).top_ideas.appropriate#.paginate(:page => params[:page])
		in_progress_ideas = Idea.with_private(current_user).in_progress_ideas(current_user).appropriate#.paginate(:page => params[:page])
		realized_ideas = Idea.with_private(current_user).realized_ideas(current_user).appropriate#.paginate(:page => params[:page])
		@ideas = {:new => new_ideas, :top => top_ideas, :in_progress => in_progress_ideas, :realized => realized_ideas}
	end

	def category
		@category = @categories.select{|x| x.id.to_s == params[:id]}
		@category = @category.first if @category.kind_of?(Array)

		if @category
			new_ideas = Idea.with_private(current_user).new_ideas.categorized_ideas(params[:id]).appropriate#.paginate(:page => params[:page])
			top_ideas = Idea.with_private(current_user).top_ideas.categorized_ideas(params[:id]).appropriate#.paginate(:page => params[:page])
			in_progress_ideas = Idea.with_private(current_user).in_progress_ideas(current_user).categorized_ideas(params[:id]).appropriate#.paginate(:page => params[:page])
			realized_ideas = Idea.with_private(current_user).realized_ideas(current_user).categorized_ideas(params[:id]).appropriate#.paginate(:page => params[:page])
			@ideas = {:new => new_ideas, :top => top_ideas, :in_progress => in_progress_ideas, :realized => realized_ideas}
		else
			flash[:info] =  t('app.msgs.does_not_exist')
			redirect_to root_path
		end
	end

	def user
		@user = User.find_by_id(params[:id])

		if @user
			new_ideas = Idea.with_private(current_user).new_ideas.user_ideas(params[:id]).appropriate#.paginate(:page => params[:page])
			top_ideas = Idea.with_private(current_user).top_ideas.user_ideas(params[:id]).appropriate#.paginate(:page => params[:page])
			in_progress_ideas = Idea.with_private(current_user).in_progress_ideas(current_user).user_ideas(params[:id]).appropriate#.paginate(:page => params[:page])
			realized_ideas = Idea.with_private(current_user).realized_ideas(current_user).user_ideas(params[:id]).appropriate#.paginate(:page => params[:page])
			@ideas = {:new => new_ideas, :top => top_ideas, :in_progress => in_progress_ideas, :realized => realized_ideas}
		else
			flash[:info] =  t('app.msgs.does_not_exist')
			redirect_to root_path
		end
	end

	def organization
		@organization = Organization.find_by_id(params[:id])
		if @organization
			latest_progress = IdeaProgress.latest_organization_idea_progress(params[:id])
			@ideas = []
			# for each idea status, get ideas with this status as the last progress report for this org
			@idea_statuses.each do |status|
				hash = Hash.new
				hash[:id] = status.id
				hash[:name] = status.name
				hash[:ideas] = []
				# if the org has an idea at this stage, get it
				if !latest_progress.select{|x| x.idea_status_id == status.id}.empty?
					hash[:ideas] = Idea.with_private(current_user).appropriate
						.where(:id => latest_progress.select{|x| x.idea_status_id == status.id}.map{|x| x.idea_id})
				end
				@ideas << hash
			end
		else
			flash[:info] =  t('app.msgs.does_not_exist')
			redirect_to root_path
		end
	end

	def search
		if params[:q]
			new_ideas = Idea.with_private(current_user).new_ideas.search_by(params[:q]).appropriate#.paginate(:page => params[:page])
			top_ideas = Idea.with_private(current_user).top_ideas.search_by(params[:q]).appropriate#.paginate(:page => params[:page])
			in_progress_ideas = Idea.with_private(current_user).in_progress_ideas(current_user).search_by(params[:q]).appropriate#.paginate(:page => params[:page])
			realized_ideas = Idea.with_private(current_user).realized_ideas(current_user).search_by(params[:q]).appropriate#.paginate(:page => params[:page])
			@ideas = {:new => new_ideas, :top => top_ideas, :in_progress => in_progress_ideas, :realized => realized_ideas}
		end
	end

  def idea
    @idea = Idea.with_private(current_user).find_by_id(params[:id])

		if @idea
			gon.show_fb_comments = true

		  respond_to do |format|
		    format.html # idea.html.erb
		    format.json { render json: @idea }
		  end
		else
			flash[:info] =  t('app.msgs.does_not_exist')
			redirect_to root_path
		end
  end

  def create
    @idea = Idea.new(params[:idea])

    previous_page = root_path
		if request.env["HTTP_REFERER"]
	    previous_page = :back
		end


    respond_to do |format|
      if @idea.save
        format.html { redirect_to idea_path(@idea), notice: 'Idea was successfully created.' }
        format.json { render json: @idea, status: :created, location: @idea }
      else
        format.html { redirect_to previous_page }
        format.json { render json: @idea.errors, status: :unprocessable_entity }
      end
    end
  end

  def vote
		redirect_path = if request.env["HTTP_REFERER"]
		    :back
			else
		    root_path
			end

    if !(['down', 'up'].include? params[:status])
      redirect_to redirect_path, :alert => 'wrong status'
      return
    end

    case params[:type]
    when 'comment'
      m = Comment
    when 'idea'
      m = Idea
    else
      redirect_to root_path, :alert => 'wrong votable'
      return
    end

    ip = request.remote_ip
    record = VoterIp.where(:ip => ip, :votable_type => params[:type], :votable_id => params[:votable_id])

    if record.nil? || record.empty?

      obj = m.find(params[:votable_id])
      if obj.individual_votes.nil? || obj.individual_votes.length < 4
        obj.individual_votes = '+0-0'
      end

      split = obj.individual_votes.split('+')[1].split('-')
      ups = split[0].to_i
      downs = split[1].to_i

      if params[:status] == 'up'
        ups = ups + 1
      elsif params[:status] == 'down'
        downs = downs + 1
      end

      obj.individual_votes = '+' + ups.to_s + '-' + downs.to_s
			obj.overall_votes = ups - downs
      obj.save

      VoterIp.create(:ip => ip, :votable_type => params[:type], :votable_id => params[:votable_id], :status => params[:status])

    elsif record[0].status != params[:status]

      obj = m.find(params[:votable_id])

      split = obj.individual_votes.split('+')[1].split('-')
      ups = split[0].to_i
      downs = split[1].to_i

      if params[:status] == 'up'
        ups = ups + 1
      elsif params[:status] == 'down'
        downs = downs + 1
      end

      obj.individual_votes = '+' + ups.to_s + '-' + downs.to_s
			obj.overall_votes = ups - downs
      obj.save

      record[0].status = params[:status]
      record[0].save
    else
	    redirect_to redirect_path
      return false
    end

    redirect_to redirect_path
  end

	def comment_notification
		idea = Idea.find_by_id(params[:idea_id])
		if idea
			# notify owner if wants notification
			if idea.user.wants_notifications
				message = Message.new
				message.email = idea.user.email
				message.subject = I18n.t('mailer.owner.new_comment.subject')
				message.message = I18n.t('mailer.owner.new_comment.message')
				message.url_id = params[:idea_id]
				NotificationOwnerMailer.new_comment(message).deliver
			end

			# notify subscribers
			message = Message.new
			message.bcc = Notification.follow_idea_users(idea.id)
			if message.bcc && !message.bcc.empty?
				# if the owner is a subscriber, remove from list
				index = message.bcc.index(idea.user.email)
				message.bcc.delete_at(index) if index
				# only continue if owner was not only subscriber
				if message.bcc.length > 0
					message.subject = I18n.t('mailer.subscriber.new_comment.subject')
					message.message = I18n.t('mailer.subscriber.new_comment.message')
					message.url_id = params[:idea_id]
					NotificationSubscriberMailer.new_comment(message).deliver
				end
			end

			render :text => "true"
			return false
		end
		render :text => "false"
		return false
	end

	def follow_idea
		idea = Idea.find_by_id(params[:idea_id])
		if idea
			Notification.create(:user_id => current_user.id,
													:identifier => idea.id,
													:notification_type => Notification::TYPES[:follow_idea])
			flash[:notice] = I18n.t('app.common.follow_idea')
			redirect_to idea_path(idea.id)
		else
			flash[:alert] = I18n.t('app.common.follow_idea_bad')
			redirect_to root_path
		end
	end

	def unfollow_idea
		idea = Idea.find_by_id(params[:idea_id])
		if idea
			Notification.where(:user_id => current_user.id,
													:identifier => idea.id,
													:notification_type => Notification::TYPES[:follow_idea]).delete_all

			flash[:notice] = I18n.t('app.common.unfollow_idea')
			redirect_to idea_path(idea.id)
		else
			flash[:alert] = I18n.t('app.common.unfollow_idea_bad')
			redirect_to root_path
		end
	end
end
