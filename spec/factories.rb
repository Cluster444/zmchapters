Factory.define :geo, :class => GeographicLocation do |f|
  f.name "Test Geo"
end

Factory.define :chapter do |f|
  f.name "Test Chapter"
  f.category Chapter::CATEGORIES.first
  f.association :geographic_location, :factory => :geo
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

Factory.define :site_option do |f|
  alpha = ('a'..'z').to_a
  f.sequence(:key) {|n| "test_key_#{alpha[n]}"}
  f.type "string"
  f.value "Test value"
  f.mutable "true"
end

Factory.define :feedback_request do |f|
  f.subject "Test Subject"
  f.message "Test Message"
  f.email "test@test.com"
  f.category FeedbackRequest::CATEGORIES.first
end
