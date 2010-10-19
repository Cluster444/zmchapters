Factory.define :chapter do |f|
  f.title 'test'
  f.description 'test'
  f.language 'test'
end

Factory.define :member do |f|
  f.name 'test test'
  f.alias 'test'
  f.email 'test@test.com'
  f.password 'foobarbaz'
  f.password_confirmation 'foobarbaz'
end
