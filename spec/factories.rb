Factory.define :geo, :class => GeographicLocation do |f|
  f.name "Test Geo"
end

Factory.define :chapter do |f|
  f.name "Test Chapter"
  f.category Chapter::CATEGORIES.first
  f.geographic_location Factory(:geo)
end

Factory.define :user do |f|
  f.name 'Test User'
  f.sequence(:username) {|n| "test#{n}" }
  f.sequence(:email) {|n| "test#{n}@test.com"}
end

Factory.define :coordinator do |f|
  f.chapter Factory(:chapter)
end
