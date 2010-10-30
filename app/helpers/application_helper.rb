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

  def edit_link(object, content = "Edit")
    link_to(content, [:edit, object]) if can? :update, object
  end

  def create_link(object, content = "Create")
    if can? :create, object
      object_class = (object.kind_of?(Class) ? object : object.class)
      link_to(content, [:new, object_class.name.underscore.to_sym])
    end
  end

  def destroy_link(object, content = "Destroy")
    link_to(content, object, :method => :delete, :confirm => "Are you sure?") if can? :destroy, object
  end

  def breadcrumb_for_nested_set(node, sep = "/")
    ((node.root? ? '' : breadcrumb_for_nested_set(node.parent) + sep) + link_to(node.name, geo_path(node))).html_safe
  end

end
