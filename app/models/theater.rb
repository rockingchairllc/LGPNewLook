class Theater < ActiveRecord::Base
  has_many :schedules, :inverse_of => :theater
  has_many :movies, :through => :schedules, :uniq => true

end
