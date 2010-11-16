class CoordinatorsController < ApplicationController
  before_filter :load_chapter

  def index
    @coordinators = Coordinator.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @coordinators }
    end
  end

  def show
    @coordinator = Coordinator.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @coordinator }
    end
  end

  def new
    @coordinator = Coordinator.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @coordinator }
    end
  end

  def create
    @coordinator = Coordinator.new(params[:coordinator].merge(:chapter_id => params[:chapter_id]))

    respond_to do |format|
      if @coordinator.save
        format.html { redirect_to(@chapter, :notice => 'Coordinator was successfully created.') }
        format.xml  { render :xml => @coordinator, :status => :created, :location => @coordinator }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @coordinator.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @coordinator = Coordinator.find(params[:id])
    @coordinator.destroy

    respond_to do |format|
      format.html { redirect_to(@chapter) }
      format.xml  { head :ok }
    end
  end

private
  
  def load_chapter
    @chapter = Chapter.find(params[:chapter_id])
  end
end
