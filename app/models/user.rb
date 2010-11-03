class User < ActiveRecord::Base
  #FIXME - Probably shouldn't expose chapter_id like this...
  attr_accessible :name, :username, :email, :password, :password_confirmation, :chapter_id, :roles_mask, :roles,
                  :geographic_location_id

  include RoleModel

  roles [:admin, :coordinator]
  
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :chapter, :counter_cache => true
  
  def geographic_location
    loc = GeographicLocation.find geographic_location_id
    "#{loc.name}, #{loc.parent.name}"
  end
end
