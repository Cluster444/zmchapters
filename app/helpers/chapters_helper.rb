module ChaptersHelper
  def link_to_chapter_request(chapter)
    link_to 'Request A Chapter', :controller => 'chapters', :action => 'new', :country => chapter.country[0]
  end
end
