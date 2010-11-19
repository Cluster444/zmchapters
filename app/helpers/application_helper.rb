module ApplicationHelper
  
  def title(page_title, show_title = true)
    content_for(:title) { page_title.to_s }
    @show_title = show_title
  end

  def show_title?
    @show_title
  end

  def css(*files)
    content_for(:head) { stylesheet_link_tag(*files) }
  end

  def js(*files)
    content_for(:head) { javascript_include_tag(*files) }
  end

  def include_wymeditor
    javascript_include_tag 'wymeditor/jquery.wymeditor.min.js'
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

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, params.merge(:sort => column, :direction => direction, :page => nil), {:class => css_class}
  end

  def admin?
    current_user and current_user.admin?
  end

  def error_messages_for(*objects)
    options = objects.extract_options!
    options[:header_message] ||= "Invalid Fields"
    options[:message] ||= "Correct the following errors and try again"
    messages = objects.compact.map { |o| o.errors.full_messages }.flatten
    unless messages.empty?
      content_tag(:div, :class => "error_messages") do
        list_items = messages.map { |msg| content_tag(:li, msg) }
        content_tag(:h2, options[:header_message]) + content_tag(:p, options[:message]) + content_tag(:ul, list_items.join.html_safe)
      end
    end
  end

  module FormBuilderAdditions
    def error_messages(options = {})
      @template.error_messages_for(@object, options)
    end
  end
end

ActionView::Helpers::FormBuilder.send(:include, ApplicationHelper::FormBuilderAdditions)
