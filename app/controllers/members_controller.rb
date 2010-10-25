class MembersController < ApplicationController
  before_filter :load_member, :only => [:show,:edit,:update]

  def show
    @chapter = @member.chapter
    @country = @chapter.country.first
  end

  def new
    @member = Member.new
  end

  def edit
  end

  def create
    @member = Member.new params[:member]
    @member.skip_confirmation!
    if @member.save
      flash[:notice] = "Member registered."
      redirect_to member_path @member
    else
      render :new
    end
  end

  def update
    if @member.update_attributes
      flash[:notice] = "Member profile udpated"
      redirect_to @member
    else
      render :edit
    end
  end

  def destroy
  end

private
  
  def load_member
    @member = Member.find params[:id]
  end
end
