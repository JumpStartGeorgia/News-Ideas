class RootController < ApplicationController

  def index
    @idea = Idea.new
		@idea.idea_categories.build
		@ideas = Idea.new_ideas
  end

	def explore
		@explore = params[:id].humanize
		@ideas = Idea.explore(params[:id])
	end

	def category
		@category = @categories.select{|x| x.id.to_s == params[:id]}
		@category = @category.first if @category.kind_of?(Array)

		@ideas = Idea.new_ideas.categorized_ideas(params[:id])
	end

  def idea
    @idea = Idea.find(params[:id])

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

end
