module HtmlHelper
  def ul(opts={}, &block)
    ListRenderer.new(self, block).to_ul
  end

  def ul_link_to(opts={}, collection)
    ul opts do |list|
      collection.each do |item|
        list.link_to(item.name, geo_path(item))
      end
    end
  end
end
