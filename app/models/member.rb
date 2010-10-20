class Member < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :alias, :email, :password, :password_confirmation
  
  belongs_to :chapter

  validates :password, :confirmation => true

  validates :email, :presence => true,
                    :uniqueness => true

end
