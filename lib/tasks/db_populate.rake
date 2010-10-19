require 'faker'

namespace :db do
  desc 'Fill database with sample data'
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    
    chapter_desc = Faker::Lorem.paragraph 10
    states = ['Alabama', 'Alaska', 'Arizona', 'Arkansas', 'California', 'Colorado', 'Connecticut', 'Delaware',
              'Florida', 'Georgia', 'Hawaii', 'Idaho', 'Illinois', 'Indiana', 'Iowa', 'Kansas', 'Kentucky',
              'Louisiana', 'Maine', 'Maryland', 'Massachusetts', 'Michigan', 'Minnesota', 'Mississippi',
              'Missouri', 'Montana', 'Nebraska', 'Nevada', 'New Hampshire', 'New Jersey', 'New Mexico',
              'New York', 'North Carolina', 'North Dakota', 'Ohio', 'Oklahoma', 'Oregon', 'Pennsylvania',
              'Rhode Island', 'South Carolina', 'South Dakota', 'Tennessee', 'Texas', 'Utah', 'Vermont',
              'Virginia', 'Washington', 'West Virginia', 'Wisconsin', 'Wyoming']
    
    global_chapter = Chapter.create! :region => 'Earth', :description => chapter_desc, :languages => 'Too Many'

    us_chapter = Chapter.create! :region => 'United States', :description => chapter_desc, :languages => 'English'

    states.each do |state|
      state_chapter = Chapter.create! :region => state, :description => chapter_desc, :languages => 'English'
    end
  end
end
