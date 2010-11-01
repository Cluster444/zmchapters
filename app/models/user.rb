class User < ActiveRecord::Base
  #FIXME - Probably shouldn't expose chapter_id like this...
  attr_accessible :name, :username, :email, :password, :password_confirmation, :chapter_id, :roles_mask, :country_id, :roles

  include RoleModel

  roles [:admin, :coordinator]
  
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :chapter, :counter_cache => true
end
