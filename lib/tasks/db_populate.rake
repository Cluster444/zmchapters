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

def new_location(name, geoname_id, parent_id, depth)
  GeographicLocation.new :name => name, :geoname_id => geoname_id, :parent_id => parent_id, :depth => depth
end

def collect_geonames(geo, parent_id, depth)
  geo.collect { |g| new_location(g[:name], g[:geonameId], parent_id, depth) } unless geo.nil?
end

def collect_children(parents, depth)
  parents.collect do |parent|
    collect_geonames(ws_fetch_children(parent.geoname_id)[:geonames], parent.id, depth) || []
  end.flatten
end

def build_children(parents, depth)
  GeographicLocation.import collect_children(parents, depth), :validate => false
  build_children(GeographicLocation.where("depth = ?", depth), depth+1) unless depth == 2
end

def guard(model, opts={}, &block)
  model.delete_all if ENV["DESTROY"] == "true"
  guarded = (opts[:if] and opts[:if].call(model)) or (not opts[:if] and model.exists?)
  yield and return unless guarded
  puts "Records exist for #{model.name}. Set the environment variable DESTROY=true to delete existing records"
end


EARTH_GEONAME_ID = 6295630

namespace :db do
  
  namespace :populate do
    desc 'Pull in country info from web service'
    
    task :countries => :environment do
      guard GeographicLocation do
        puts "Fetching geographic territories from geonames"
        earth = GeographicLocation.new(:geoname_id => EARTH_GEONAME_ID)
        build_children([earth], 0)
        
        puts "Building nested set links (this may take a minute)"
        GeographicLocation.rebuild!
      end
    end
  
    desc 'Populate database with chapters'
    task :chapters => :countries do
      guard Chapter do
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
      guard ExternalUrl do
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
      guard SiteOption do
        puts "Setting site registration to open"
        SiteOption.create! :key => 'site_registration', :type => 'string', :value => 'open', :mutable => true
        puts "Setting feedback status to open"
        SiteOption.create! :key => 'feedback_status',   :type => 'string', :value => 'open', :mutable => true
      end
    end
    
    desc "Populate the database with default pages"
    task :pages => :environment do
      guard Page do
        content = 5.times.collect { "<p>"+Faker::Lorem.paragraph(10)+"</p>" }
        puts "Creating protocols page"
        Page.create! :uri => 'protocols', :title => "Protocols", :content => content, :layout => 'one-column'
        puts "Creating home page"
        Page.create! :uri => 'home', :title => "ZM Chapters", :content => content, :layout => 'two-column'
      end
    end

    desc "Populate the database with feedback"
    task :feedback, [:anon_count,:user_count] => :environment do |t,args|
      args.with_defaults(:anon_count => 10, :user_count => 10)
      guard FeedbackRequest do
        puts "Generating new feedback"
        cat_count = FeedbackRequest::CATEGORIES.count
        state_count = FeedbackRequest::STATES.count
        users = (1..5).collect do |i|
          username = Faker::Internet.user_name
          User.create! :name => Faker::Name.name,
                       :username => username,
                       :email => [username,Faker::Internet.domain_name].join("@"),
                       :password => 'testpass',
                       :password_confirmation => 'testpass'
        end
        requests = []
        puts "Creating #{args.anon_count} feedback records from anonymous users"
        requests << 1.upto(args.anon_count.to_i).collect do |i|
          FeedbackRequest.new :email => Faker::Internet.email,
                              :category => FeedbackRequest::CATEGORIES[i % cat_count],
                              :status => FeedbackRequest::STATES[i % state_count],
                              :subject => Faker::Lorem.sentence(6),
                              :message => Faker::Lorem.paragraph(5)
        end
        puts "Creating #{args.user_count} feedback records from registered users"
        requests << 1.upto(args.user_count.to_i).collect do |i|
          FeedbackRequest.new :category => FeedbackRequest::CATEGORIES[i % cat_count],
                              :status => FeedbackRequest::STATES[i % state_count],
                              :subject => Faker::Lorem.sentence(6),
                              :message => Faker::Lorem.paragraph(5),
                              :user_id => users[i%5].id
        end
        FeedbackRequest.import requests.flatten, :validate => false
      end
    end
      
    desc 'Populate the database with all information'
    task :all => [:chapters, :site_options, :pages, :feedback] do
      guard User, :if => proc {|u| u.where(:admin => true).any?}, do
        puts "Creating an admin user with email admin@zmchapters.com and password adminpass"
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
