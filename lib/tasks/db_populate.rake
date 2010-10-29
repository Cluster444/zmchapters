require 'faker'

GEONAME_DIR = Rails.root + "geonames"

def ws_fetch_children(geoname_id)
  cache_name = "#{GEONAME_DIR}/#{geoname_id}.json"
  unless File.exist? cache_name
    uri = URI.parse("http://ws.geonames.org/childrenJSON?geonameId=#{geoname_id}")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    request.initialize_http_header({"User-Agent" => "Rails 3.0.0"})
    response = http.request(request)
    data = response.body
    data.force_encoding('UTF-8').encode!
    File.open(cache_name, 'w') {|f| f.write(data)}
  else
    data = ""
    File.open(cache_name, 'r') do |cache_file|
      while(line = cache_file.gets)
        data += line
      end
    end
  end
  JSON.parse(data, :symbolize_names => true)
end

def make_territory(territory)
  GeographicTerritory.create! :name => territory[:name],
                              :geoname_id => territory[:geonameId],
                              :fcode => territory[:fcode]
end

EARTH = {
  :name => "Earth",
  :geoname_id => 6295630,
  :fcode => "EARTH"
}

namespace :db do
  
  namespace :populate do
    desc 'Pull in country info from web service'
    
    task :countries => :environment do
      unless GeographicTerritory.all.any?
        puts "Fetching geographic territories from geonames"
        earth = GeographicTerritory.create! EARTH
        ws_continents = ws_fetch_children(earth.geoname_id)

        ws_continents[:geonames].each do |ws_continent|
          puts "Generating #{ws_continent[:name]}"
          continent = make_territory(ws_continent)
          continent.move_to_child_of earth
          ws_countries = ws_fetch_children(continent.geoname_id)
          
          ws_countries[:geonames].each do |ws_country|
            puts " - Generating #{ws_country[:name]}"
            country = make_territory(ws_country)
            country.move_to_child_of continent
            ws_territories = ws_fetch_children(country.geoname_id)

              ws_territories[:geonames].each do |ws_territory|
                territory = make_territory(ws_territory)
                territory.move_to_child_of country
              end unless ws_territories[:geonames].nil?
          end
        end
      end
    end
  
    desc 'Populate database with chapters'
    task :chapters => :countries do
      unless Chapter.all.any?
        puts "Generating chapters"
        GeographicTerritory.countries.each do |country|
          Chapter.create! :region => country.name, :geographic_territory_id => country.id
          country.children.each do |territory|
            Chapter.create! :region => territory.name, :geographic_territory_id => territory.id
          end
        end 
      end
    end

    desc 'Populate database with users'
    task :users => :chapters do
      unless User.all.any?
        puts "Generating users"
        i = 1
        count = Chapter.all.count
        Chapter.roots.each do |country_chapter|
          puts "#{i}/#{count}"
          i += 1
          country_chapter.leaves.each do |sub_chapter|
            (1..(Random.rand(10)+1)).each do |n|
              user = sub_chapter.users.new :name => Faker::Name.name,
                                       :alias => Faker::Internet.user_name,
                                       :email => Faker::Internet.email,
                                       :password => 'foobarbaz',
                                       :password_confirmation => 'foobarbaz',
                                       :country_id => country_chapter.country.id
              user.skip_confirmation!
              user.save!
            end
          end
        end
      end
    end
    
    desc 'Populate database with links'
    task :links => :chapters do
      unless ExternalUrl.all.any?
        puts "Generate external urls"
        i = 1
        count = Chapter.all.count
        Chapter.all.each do |chapter|
          puts "#{i}/#{count}"
          i += 1
          url = Faker::Internet.domain_name
          chapter.external_urls.create! :url => "#{url}",                 :title => 'website', :type => 'hyperlink', :sort_order => 1
          chapter.external_urls.create! :url => "#{url}/forum",           :title => 'forum',   :type => 'hyperlink', :sort_order => 2
          chapter.external_urls.create! :url => "#{url}/blog",            :title => 'blog',    :type => 'hyperlink', :sort_order => 3
          chapter.external_urls.create! :url => "#{url}/feeds.rss",       :title => 'website', :type => 'rss', :sort_order => 1
          chapter.external_urls.create! :url => "#{url}/forum/feeds.rss", :title => 'forum',   :type => 'rss', :sort_order => 2
          chapter.external_urls.create! :url => "#{url}/blog/feeds.rss",  :title => 'blog',    :type => 'rss', :sort_order => 3
        end
      end
    end

    desc 'Populate the database with all information'
    task :all => [:users, :links] do
    end
  end
  
  desc 'Perform db:populate:all with a db:reset before'
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    Rake::Task['db:populate:all'].invoke
    states = ['Alabama', 'Alaska', 'Arizona', 'Arkansas', 'California', 'Colorado', 'Connecticut', 'Delaware',
              'Florida', 'Georgia', 'Hawaii', 'Idaho', 'Illinois', 'Indiana', 'Iowa', 'Kansas', 'Kentucky',
              'Louisiana', 'Maine', 'Maryland', 'Massachusetts', 'Michigan', 'Minnesota', 'Mississippi',
              'Missouri', 'Montana', 'Nebraska', 'Nevada', 'New Hampshire', 'New Jersey', 'New Mexico',
              'New York', 'North Carolina', 'North Dakota', 'Ohio', 'Oklahoma', 'Oregon', 'Pennsylvania',
              'Rhode Island', 'South Carolina', 'South Dakota', 'Tennessee', 'Texas', 'Utah', 'Vermont',
              'Virginia', 'Washington', 'West Virginia', 'Wisconsin', 'Wyoming']
    
    
  end
end
