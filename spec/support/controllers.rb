def record_invalid(model)
  raise ActiveRecord::RecordInvalid.new(model)
end
