class ChaptersController < ApplicationController
  load_and_authorize_resource :chapter
  helper_method :sort_column, :sort_direction

  rescue_from ActiveRecord::RecordNotFound do
    flash[:error] = "Chapter not found"
    redirect_to chapters_url
  end

  def index
    @chapters = Chapter.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:per_page => 20, :page => params[:page])
  end

  def show
    @chapter = Chapter.find params[:id]
  end

  def search
    result = Chapter.search_name params[:search_name]
    if result.class == Chapter
      @chapter = result
      render :show
    else
      @chapters = result
      render :index
    end
  end

  def new
    @chapter = Chapter.new params[:chapter]
    location = GeographicLocation.find(params[:location_id]) rescue nil
    case(params[:category])
      when "country"
        @chapter.name = params[:name]
        @chapter.category = "country"
        @chapter.geographic_location = location
      when "subcountry"
        @chapter.name = params[:name]
        @chapter.category = "territory"
        @chapter.geographic_location = location
      when "subterritory"
        @parent_location = location
      else
        if params[:commit] = "Lookup"
          unless location.children.collect(&:name).include?(@chapter.name)
            g = GeographicLocation.create! :name => @chapter.name
            g.move_to_child_of(location)
            @chapter.geographic_location = g
            flash[:notice] = "Created new geography for #{@chapter.name}"
          else
            @chapter.geographic_location = location.children.reject {|c| c.name != @chapter.name}.first
          end
        end
    end 
  end

  def edit
    @chapter = Chapter.find params[:id]
  end
  
  
  def create
    location = GeographicLocation.find params[:location_id]
    location.update_attributes! params[:geo] unless params[:geo].nil?
    @chapter = Chapter.new params[:chapter]
    @chapter.geographic_location = location
    @chapter.save!
    flash[:notice] = "Chapter created successfully"
    redirect_to chapter_url(@chapter)
  rescue ActiveRecord::RecordInvalid
    render :new
  end

  def update
    @chapter = Chapter.find params[:id]
    @chapter.update_attributes! params[:chapter]
    flash[:notice] = "Chapter updated successfully"
    redirect_to chapter_url(@chapter)
  rescue ActiveRecord::RecordInvalid
    render :edit
  end

  def destroy
    @chapter = Chapter.find params[:id]
    @chapter.destroy
    flash[:notice] = "Chapter has been removed"
    redirect_to chapters_url
  end

private
  
  def sort_column
    Chapter.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
