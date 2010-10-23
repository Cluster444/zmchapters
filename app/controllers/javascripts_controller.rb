class JavascriptsController < ApplicationController
  def dynamic_chapters
    @chapters = Chapter.all
  end
end
