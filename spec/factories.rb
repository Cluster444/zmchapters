Factory.define :chapter do |f|
  f.name "Test Chapter"
  f.category Chapter::CATEGORIES.first
  f.association :geographic_location, :factory => :location
end

Factory.define :coordinator do |f|
  f.association :user, :factory => :user_with_chapter
end

Factory.define :coordinator_with_chapter, :class => Coordinator do |f|
  f.association :user
  f.association :chapter
end

Factory.define :event do |f|
  f.title "Test Event"
  f.description "Description of Test Event"
  f.starts_at DateTime.now + 1.hour
  f.ends_at DateTime.now + 2.hours
end

Factory.define :chapter_event, :parent => :event do |f|
  f.association :plannable, :factory => :chapter
end

Factory.define :user_event, :parent => :event do |f|
  f.association :plannable, :factory => :user
end

Factory.define :feedback_request do |f|
  f.subject "Test Subject"
  f.message "Test Message"
  f.email "test@test.com"
  f.category FeedbackRequest::CATEGORIES.first
end

Factory.define :link do |f|
  f.url "test.com"
  f.title "Test Link"
  f.association :linkable, :factory => :chapter
end

Factory.define :location, :class => GeographicLocation do |f|
  f.name "Test Geo"
  f.lat "0"
  f.lng "0"
  f.zoom "2"
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

Factory.define :user do |f|
  f.name 'Test User'
  f.sequence(:username) {|n| "test#{n}" }
  f.sequence(:email) {|n| "test#{n}@test.com"}
  f.password 'testpassword'
  f.password_confirmation { |u| u.password }
end

Factory.define :user_with_chapter, :parent => :user do |f|
  f.association :chapter
end

Factory.define :admin, :parent => :user do |f|
  f.after_create(&:is_admin!)
end

Factory.define :test_index do |f|
  f.sequence(:name) { |n| "Item #{n}" }
end
