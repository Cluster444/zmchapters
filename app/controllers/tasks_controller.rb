class TasksController < ApplicationController
  load_and_authorize_resource
  
  before_filter :load_taskable, :only => [:new, :create]

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

private
  
  def load_taskable
    raise NameError if params[:taskable][:type].blank?
    @task.taskable = eval "#{params[:taskable][:type]}.find #{params[:taskable][:id]}"
  rescue NameError
    redirect_to Task, :alert => "Task needs to be created with a taskable type"
  rescue ActiveRecord::RecordNotFound
    redirect_to Task, :alert => "No #{params[:taskable][:type]} found."
  end
end
