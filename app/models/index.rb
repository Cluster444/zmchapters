module Index
  class Handler
    def initialize(model, block)
      block.call(self)
      @where = @search_columns.collect { |c| "#{c} LIKE :search" }.join(' OR ') rescue false
      @per_page ||= 20
    end

    def paginate(per_page)
      @per_page = per_page
    end
    
    def search(*columns)
      @search_columns = columns
    end

    def sort(*columns)
      @sort_columns = columns.to_s
    end

    def default_sort(column, direction)
      @default_sort_column = column.to_s
      @default_sort_direction = direction.to_s
    end

    def sort_column(param)
      if (param.blank?) || (not @sort_columns.include?(param))
        @default_sort_column
      else
        param
      end
    end

    def sort_direction(param)
      if (param.blank?) || (not %w(asc desc).include?(param))
        @default_sort_direction
      else
        param
      end
    end

    def call(arel, params)
      arel = arel.where(@where, :search => "%#{params[:search]}%") if @where
      if @sort_columns
        arel = arel.order("#{sort_column(params[:sort])} #{sort_direction(params[:direction])}")
      end
      params[:per_page] ||= @per_page
      arel.paginate(:page => params[:page], :per_page => params[:per_page])
    end
  end

  def index(&block)
    @handler = Handler.new(self, block)
  end

  def search(params={})
    @handler.call(self.scoped, params.to_options)
  end
end
