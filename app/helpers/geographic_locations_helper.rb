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
end
