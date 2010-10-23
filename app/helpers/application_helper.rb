module ApplicationHelper
  
  def title(page_title)
    content_for(:title) { page_title }
  end

  def css(*files)
    content_for(:head) { stylesheet_link_tag(*files) }
  end

  def js(*files)
    content_for(:head) { javascript_include_tag(*files) }
  end

end
