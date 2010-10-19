class Member < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :alias, :email, :password, :password_confirmation, :chapter_id

  validates :password, :confirmation => true

  validates :email, :presence => true,
                    :uniqueness => true

end
