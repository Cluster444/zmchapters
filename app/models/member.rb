class Member < ActiveRecord::Base
  attr_accessor :password
  #FIXME - Probably shouldn't expose chapter_id like this...
  attr_accessible :name, :alias, :email, :password, :password_confirmation, :chapter_id
  
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :chapter
end
