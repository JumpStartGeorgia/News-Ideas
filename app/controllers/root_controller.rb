class RootController < ApplicationController

  def index
    respond_to do |format|
      format.html {
				new_ideas = Idea.new_ideas.appropriate.paginate(:page => params[:page])
				top_ideas = Idea.top_ideas.appropriate.paginate(:page => params[:page])
				in_progress_ideas = Idea.in_progress_ideas.appropriate.paginate(:page => params[:page])
				realized_ideas = Idea.realized_ideas.appropriate.paginate(:page => params[:page])
				@ideas = {:new => new_ideas, :top => top_ideas, :in_progress => in_progress_ideas, :realized => realized_ideas}
				render :layout => 'application_home'
      }
      format.js {
				# test which tab to get data for
				@ideas = nil
				case params[:tab]
					when @id_new
						@ideas = Idea.new_ideas.appropriate.paginate(:page => params[:page])
					when @id_top
						@ideas = Idea.top_ideas.appropriate.paginate(:page => params[:page])
					when @id_in_progress
						@ideas = Idea.in_progress_ideas.appropriate.paginate(:page => params[:page])
					when @id_realized
						@ideas = Idea.realized_ideas.appropriate.paginate(:page => params[:page])
				end
			}
    end


  end

	def explore
		@explore = params[:id].humanize
		gon.initial_tab_id = case params[:id]
			when 'top'
				gon.id_top
			when 'new'
				gon.id_new
			when 'in_progress'
				gon.id_in_progress
			when 'realized'
				gon.id_realized
		end

		new_ideas = Idea.new_ideas.appropriate
		top_ideas = Idea.top_ideas.appropriate
		in_progress_ideas = Idea.in_progress_ideas.appropriate
		realized_ideas = Idea.realized_ideas.appropriate
		@ideas = {:new => new_ideas, :top => top_ideas, :in_progress => in_progress_ideas, :realized => realized_ideas}
	end

	def category
		@category = @categories.select{|x| x.id.to_s == params[:id]}
		@category = @category.first if @category.kind_of?(Array)

		new_ideas = Idea.new_ideas.categorized_ideas(params[:id]).appropriate
		top_ideas = Idea.top_ideas.categorized_ideas(params[:id]).appropriate
		in_progress_ideas = Idea.in_progress_ideas.categorized_ideas(params[:id]).appropriate
		realized_ideas = Idea.realized_ideas.categorized_ideas(params[:id]).appropriate
		@ideas = {:new => new_ideas, :top => top_ideas, :in_progress => in_progress_ideas, :realized => realized_ideas}
	end

	def user
		@user = User.find_by_id(params[:id])

		new_ideas = Idea.new_ideas.user_ideas(params[:id]).appropriate
		top_ideas = Idea.top_ideas.user_ideas(params[:id]).appropriate
		in_progress_ideas = Idea.in_progress_ideas.user_ideas(params[:id]).appropriate
		realized_ideas = Idea.realized_ideas.user_ideas(params[:id]).appropriate
		@ideas = {:new => new_ideas, :top => top_ideas, :in_progress => in_progress_ideas, :realized => realized_ideas}
	end

	def organization
		@organization = Organization.find_by_id(params[:id])

		in_progress_ideas = Idea.in_progress_ideas.organization_ideas(params[:id]).appropriate
		realized_ideas = Idea.realized_ideas.organization_ideas(params[:id]).appropriate
		@ideas = {:new => nil, :top => nil, :in_progress => in_progress_ideas, :realized => realized_ideas}
	end

	def search
		if params[:q]
			new_ideas = Idea.new_ideas.search_by(params[:q]).appropriate
			top_ideas = Idea.top_ideas.search_by(params[:q]).appropriate
			in_progress_ideas = Idea.in_progress_ideas.search_by(params[:q]).appropriate
			realized_ideas = Idea.realized_ideas.search_by(params[:q]).appropriate
			@ideas = {:new => new_ideas, :top => top_ideas, :in_progress => in_progress_ideas, :realized => realized_ideas}
		end
	end

  def idea
    @idea = Idea.find(params[:id])
		gon.show_fb_comments = true

    respond_to do |format|
      format.html # idea.html.erb
      format.json { render json: @idea }
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
        downs = downs - 1
      elsif params[:status] == 'down'
        ups = ups - 1
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
end
