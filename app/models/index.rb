module Index
  DEFAULT_OPTIONS = {:sort => 'name', :direction => 'asc', :per_page => 20, :page => 1}
  def index(opts={})
    opts = DEFAULT_OPTIONS.merge(opts).to_options
    arel = order("#{opts[:sort]} #{opts[:direction]}")
    if search.any?
      query = search.collect do |column|
        "#{column} LIKE :search"
      end.join(' OR ')
      arel = arel.where(query, {:search => "%#{opts[:search]}%"})
    end
    arel.paginate(:per_page => opts[:per_page], :page => opts[:page])
  end

  def search_columns(*columns)
    @search_columns = columns
  end
  
  def search
    @search_columns || []
  end
end
