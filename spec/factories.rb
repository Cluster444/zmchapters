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
  f.password 'testpassword'
  f.password_confirmation 'testpassword'
end

Factory.define :admin, :parent => :user do |f|
  f.after_create(&:is_admin!)
end

Factory.define :coordinator do |f|
  f.chapter Factory(:chapter)
end

Factory.define :page do |f|
  f.uri "test_page"
  f.title "Test Page"
  f.content "Test Content"
end
