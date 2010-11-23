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
  GeographicLocation.create! :name => territory[:name],
                              :geoname_id => territory[:geonameId],
end

def new_location(name, geoname_id, parent_id, depth)
  GeographicLocation.new :name => name, :geoname_id => geoname_id, :parent_id => parent_id, :depth => depth
end

EARTH = {
  :name => "Earth",
  :geoname_id => 6295630,
}

namespace :db do
  
  namespace :populate do
    desc 'Pull in country info from web service'
    
    task :countries => :environment do
      unless GeographicLocation.all.any?
        puts "Fetching geographic territories from geonames"
        earth = GeographicLocation.create! EARTH
        ws_continents = ws_fetch_children(earth.geoname_id)

        ws_continents[:geonames].each do |ws_continent|
          puts "Generating #{ws_continent[:name]}"
          continent = make_territory(ws_continent)
          continent.move_to_child_of earth
          ws_countries = ws_fetch_children(continent.geoname_id)
          
          ws_countries[:geonames].each do |ws_country|
            country = make_territory(ws_country)
            country.move_to_child_of continent
            ws_t = ws_fetch_children(country.geoname_id)
              
            unless ws_t[:geonames].nil?
              territories = ws_t[:geonames].collect { |t| new_location(t[:name], t[:geonameId], country.id, 3) }
              GeographicLocation.import territories, :validate => false
            end
          end
        end
        puts "Building nested set links (this may take a minute)"
        GeographicLocation.rebuild!
      end
    end
  
    desc 'Populate database with chapters'
    task :chapters => :countries do
      unless Chapter.all.any?
        puts "Generating chapters"
        chapters = []
        GeographicLocation.countries.each do |country|
          chapters << Chapter.new(:name => country.name, :geographic_location_id => country.id, :category => 'country')
          country.children.each do |territory|
            chapters << Chapter.new(:name => territory.name, :geographic_location_id => territory.id, :category => 'territory')
          end
        end 
        Chapter.import chapters, :validate => false
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
    
    desc "Populate the database with required site options"
    task :site_options => :environment do
      SiteOption.create! :key => 'site_registration', :type => 'string', :value => 'closed', :mutable => false
    end
    
    desc "Populate the database with default pages"
    task :pages => :environment do
      Page.create! :uri => 'protocols', :title => "Protocols", :content => "TODO"
    end
      
    desc 'Populate the database with all information'
    task :all => [:chapters, :site_options, :pages] do
      if Rails.env.development?
        u = User.create! :name => "Dev Admin",
                         :username => 'admin',
                         :email => 'admin@zmchapters.com',
                         :password => 'adminpass',
                         :password_confirmation => 'adminpass'
        u.is_admin!
      end
    end
  end
  
  desc 'Perform db:populate:all with a db:reset before'
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    Rake::Task['db:populate:all'].invoke
  end
end
