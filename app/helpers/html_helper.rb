module HtmlHelper
  def paginate(collection, opts={})
    content_tag(:center, will_paginate(collection, opts))
  end

  def gravatar_for(user, opts={})
    gravatar_image_tag(user.email, :alt => user.name, :class => 'gravatar', :gravatar => opts[:gravatar])
  end

  def ul(opts={}, &block)
    ListRenderer.new(self, block).to_ul
  end

  def ul_link_to(collection, opts={})
    ul opts do |list|
      collection.each do |item|
        list.link_to(item.name, geo_path(item))
      end
    end
  end
end
