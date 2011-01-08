def record_invalid(model)
  raise ActiveRecord::RecordInvalid.new(model)
end

def record_not_found
  raise ActiveRecord::RecordNotFound
end
