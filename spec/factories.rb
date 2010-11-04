Factory.define :user do |f|
  f.name 'Test User'
  f.sequence(:username) {|n| "test#{n}" }
  f.sequence(:email) {|n| "test#{n}@test.com"}
end

Factory.define :geo, :class => GeographicLocation do |f|
end

Factory.define :chapter do |f|
end

Factory.define :geo_with_chapters, :parent => :geo do |f|
  f.after_build do |geo|
    geo.chapters = [Factory.build(:chapter, :geographic_location => geo)]
  end
end

Factory.define :chapter_with_users, :parent => :chapter do |f|
  f.after_build do |chapter|
    chapter.users = [Factory.build(:user, :chapter => chapter)]
  end
end
