module LayoutHelper
  def title(page_title, show_title = true)
    content_for(:title) { page_title.to_s }
    @show_title = show_title
  end

  def show_title?
    @show_title
  end

  def css(*files)
    content_for(:css) { stylesheet_link_tag(*files) }
  end

  def js(*files)
    content_for(:js) { javascript_include_tag(*files) }
  end

  def page_class(classes)
    content_for(:page_class) { classes.to_s }
  end

  def page_head_class(classes)
    content_for(:page_head_class) { classes }
  end

  def simple_page_head(content)
    content_for(:page_head, content_tag(:h1, content))
  end
end