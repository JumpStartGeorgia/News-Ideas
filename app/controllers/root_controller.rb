class RootController < ApplicationController

  def index
    @idea = Idea.new
		@ideas = Idea.new_ideas
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
