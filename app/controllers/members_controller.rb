class MembersController < ApplicationController
  
  def show
    @member = Member.find params[:id]
    @chapter = @member.chapter
    @country = @chapter.country.first
  end
end
