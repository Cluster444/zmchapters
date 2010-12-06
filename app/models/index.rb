module Index
  DEFAULT_OPTIONS = {:sort => 'name', :direction => 'asc', :per_page => 20, :page => 1}
  def index(opts={})
    opts = DEFAULT_OPTIONS.merge(opts).to_options
    where("name LIKE ?", "%#{opts[:search]}%").order("#{opts[:sort]} #{opts[:direction]}").paginate(:per_page => opts[:per_page], :page => opts[:page])
  end
end
