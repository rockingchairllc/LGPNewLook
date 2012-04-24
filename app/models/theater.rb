class Theater < ActiveRecord::Base
  has_many :schedules, :inverse_of => :theater
  has_many :movies, :through => :schedules, :uniq => true

  #attr_accessor :dist

  def self.nearold(zip, radius)
    ziploc = ZipLoc.find_by_zip(zip)
    where(["miles_between_lat_long(?, ?,
                                theaters.latitude, theaters.longitude) < ?",
           ziploc.lat, ziploc.lng, radius])
  end

  def self.near(zip, radius)
    ziploc = ZipLoc.find_by_zip(zip)
    where(["sqrt(69.1*(theaters.latitude - :ziplat)*69.1*(theaters.latitude - :ziplat)
            + 69.1*(theaters.longitude - :ziplng)*69.1*(theaters.longitude - :ziplng)) < :rad",
           :ziplat=>ziploc.lat, :ziplong=>ziploc.lng, :rad=>radius])
  end




end

