class Movie < ActiveRecord::Base
  has_many :schedules, :inverse_of => :movie
  has_many :theaters, :through => :schedules, :uniq => true
end
