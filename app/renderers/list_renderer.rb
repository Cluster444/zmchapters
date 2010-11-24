class ListRenderer
  class List
    def initialize(template)
      @items = []
      @template = template
    end

    def method_missing(method, *args, &block)
      @items << ListItem.new(method, *args, &block)
      nil
    end

    def render
      items = []
      @items.each_with_index do |item, i|
        place = case i
        when 0 then               :first
        when (@items.size-1) then :last
        else
          nil
        end
        items << item.render(@template, place.to_s)
      end
      items.join.html_safe
    end
  end

  class ListItem
    def initialize(method, *args, &block)
      @method = method
      @args = args
      @block = block
    end

    def render(template, place=nil)
      template.content_tag(:li, template.send(@method, *@args, &@block), :class => place)
    end
  end

  def initialize(template, block, options={})
    @template = template
    @options = options
    @block = block
    @list = List.new(template)
    block.call(@list)
  end

  def to_ul
    @template.content_tag(:ul, @list.render, :class => @options[:class]) 
  end

  def to_ol
    @template.content_tag(:ol, @list.render, :class => @options[:class])
  end
end
