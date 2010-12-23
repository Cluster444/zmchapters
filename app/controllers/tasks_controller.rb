class TasksController < ApplicationController
  load_and_authorize_resource

  before_filter :only => [:new, :create] do |controller|
    controller.load_polymorphic :taskable
  end
  
  def index
    @tasks = @tasks.search(index_params)
  end

  def show; end

  def new; end

  def edit; end

  def create
    @task.save!
    redirect_to @task, :notice => 'Task created successfully'
  rescue ActiveRecord::RecordInvalid
    render :new
  end

  def update
    @task.update_attributes! params[:task]
    redirect_to @task, :notice => 'Task update successfully'
  rescue ActiveRecord::RecordInvalid
    render :edit
  end

  def destroy
    @task.destroy
    redirect_to Task, :notice => 'Task removed successfully'
  end
end
