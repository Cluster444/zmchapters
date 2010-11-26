module GeographicLocationsHelper
  def full_location_section(title, elements)
    content_tag :section do
      content_tag(:h1, title) + ul_link_to(elements)
    end
  end

  def collapsed_location_section(title, content, expand_path)
    content_tag :section do
      content_tag(:h1, title) + content_tag(:ul, :class => 'collapsed') do
        content_tag(:li, content) + content_tag(:li, link_to('Show All', expand_path), :class => 'expand')
      end
    end
  end

  def breadcrumbs_for_location(location)
    location.ancestors.collect {|l| link_to(l.name, geo_path(l)) } << location.name
  end

  def link_to_new_chapter(location)
    if location.is_territory?
      link_to("Create Chapter", new_chapter_path(:location_id => location.id))
    elsif location.is_country? and not location.chapters.any?
      link_to("Create Chapter", new_chapter_path(:location_id => location.id, :name => location.name, :category => 'country'))
    end
  end
end
