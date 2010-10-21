class Member < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :alias, :email, :password, :password_confirmation
  
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :chapter
end
