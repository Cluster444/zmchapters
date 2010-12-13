xml.instruct!
xml.data do
  @events.each do |event|
    xml.event("id" => event.id) do
      xml.text event.title
      xml.start_date event.starts_at
      xml.end_date event.ends_at
    end
  end
end
