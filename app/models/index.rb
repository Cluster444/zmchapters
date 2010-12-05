module Index
  def index(opts={})
    if opts.any?
      where("name LIKE ?", "%#{opts[:search]}%").order("#{opts[:sort]} #{opts[:direction]}").paginate(:per_page => opts[:per_page], :page => opts[:page])
    else
      order("name ASC").paginate(:per_page => 20, :page => 1)
    end
  end
end
