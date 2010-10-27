require 'faker'

namespace :db do
  
  namespace :populate do
    desc 'Pull in country info from web service'
    
    task :countries => :environment do
      unless Country.all.any?
        puts "Fetching country information from geonames.org"
        uri = URI.parse("http://ws.geonames.org/countryInfoJSON")
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Get.new(uri.request_uri)
        request.initialize_http_header({"User-Agent" => "Ruby/Rails"})
        response = http.request(request)
        data = JSON.parse(response.body, :symbolize_names => true)
        
        data[:geonames].each do |country|
          Country.create! :name          => country[:countryName],
                          :currency_code => country[:currencyCode],
                          :fips_code     => country[:fipsCode],
                          :country_code  => country[:countryCode],
                          :iso_numeric   => country[:isoNumeric],
                          :capital       => country[:capital],
                          :area_in_sq_km => country[:areaInSqKm],
                          :languages     => country[:languages],
                          :iso_alpha3    => country[:isoAlpha3],
                          :continent     => country[:continent],
                          :geoname_id    => country[:geonameId],
                          :population    => country[:population]
        end
      end
    end
  
    desc 'Populate database with chapters'
    task :chapters => :countries do
      unless Chapter.all.any?
        puts "Generating chapters"
        chapter_desc = Faker::Lorem.paragraph 10
        Country.all.each do |country|
          (1..(Random.rand(4)+1)).each do |n|
            country.chapters.create! :region => Faker::Address.city, :description => chapter_desc
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
        Chapter.all.each do |chapter|
          puts "#{i}/#{count}"
          i += 1
          (1..(Random.rand(10)+1)).each do |n|
            user = chapter.users.new :name => Faker::Name.name,
                                    :alias => Faker::Internet.user_name,
                                    :email => Faker::Internet.email,
                                    :password => 'foobarbaz',
                                    :password_confirmation => 'foobarbaz',
                                    :country_id => chapter.country.id
            user.skip_confirmation!
            user.save!
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
