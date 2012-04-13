class Theater < ActiveRecord::Base
  has_many :schedules, :inverse_of => :theater
  has_many :movies, :through => :schedules, :uniq => true

  #attr_accessor :dist

  def self.near(zip, radius)
    ziploc = ZipLoc.find_by_zip(zip)
    where(["miles_between_lat_long(?, ?,
                                theaters.latitude, theaters.longitude) < ?",
                                ziploc.lat, ziploc.lng, radius])
  end

end
