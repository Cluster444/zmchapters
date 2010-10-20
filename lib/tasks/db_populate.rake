require 'faker'

namespace :db do
  desc 'Fill database with sample data'
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    states = ['Alabama', 'Alaska', 'Arizona', 'Arkansas', 'California', 'Colorado', 'Connecticut', 'Delaware',
              'Florida', 'Georgia', 'Hawaii', 'Idaho', 'Illinois', 'Indiana', 'Iowa', 'Kansas', 'Kentucky',
              'Louisiana', 'Maine', 'Maryland', 'Massachusetts', 'Michigan', 'Minnesota', 'Mississippi',
              'Missouri', 'Montana', 'Nebraska', 'Nevada', 'New Hampshire', 'New Jersey', 'New Mexico',
              'New York', 'North Carolina', 'North Dakota', 'Ohio', 'Oklahoma', 'Oregon', 'Pennsylvania',
              'Rhode Island', 'South Carolina', 'South Dakota', 'Tennessee', 'Texas', 'Utah', 'Vermont',
              'Virginia', 'Washington', 'West Virginia', 'Wisconsin', 'Wyoming']
    
    # Countries
    puts "Fetching country info from geonames.org"
    uri = URI.parse("http://ws.geonames.org/countryInfoJSON")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    request.initialize_http_header({"User-Agent" => "Ruby/Rails"})
    response = http.request(request)
    data = JSON.parse(response.body, :symbolize_names => true)
    
    chapter_desc = Faker::Lorem.paragraph 10
    
    i = 1
    count = data[:geonames].count
    data[:geonames].each do |element|
      puts "(#{i}/#{count}) #{element[:countryName]}"
      i += 1
      country = Country.create! :name          => element[:countryName],
                                :currency_code => element[:currencyCode],
                                :fips_code     => element[:fipsCode],
                                :country_code  => element[:countryCode],
                                :iso_numeric   => element[:isoNumeric],
                                :capital       => element[:capital],
                                :area_in_sq_km => element[:areaInSqKm],
                                :languages     => element[:languages],
                                :iso_alpha3    => element[:isoAlpha3],
                                :continent     => element[:continent],
                                :geoname_id    => element[:geonameId],
                                :population    => element[:population]
      (1..(Random.rand(4)+1)).each do |n|
        chapter = country.chapters.create! :region => Faker::Address.city, :description => chapter_desc
        (1..(Random.rand(10)+1)).each do |n|
          chapter.members.create! :name => Faker::Name.name,
                                  :alias => Faker::Internet.user_name,
                                  :email => Faker::Internet.email,
                                  :password => 'foobarbaz',
                                  :password_confirmation => 'foobarbaz'
        end
      end
    end
  end
end
