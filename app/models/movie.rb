class Movie < ActiveRecord::Base
  has_many :schedules, :inverse_of => :movie
  has_many :theaters, :through => :schedules, :uniq => true
  has_many :watch_lists
  has_many :watchlisters, :source => :user, :through => :watch_lists
  has_attached_file :poster, :storage => :s3, :s3_credentials => "#{Rails.root}/config/s3.yml", :path => "movieposters/:id/:filename"


  def self.nearold(zip, radius)
    ziploc = ZipLoc.find_by_zip(zip)

    # TODO: you need error handling if there is no zip code found...
    #  this is temporary...
    ziploc=ZipLoc.first unless ziploc

    includes([:theaters]).where(["miles_between_lat_long(?, ?,
                                                      theaters.latitude, theaters.longitude) < ?",
                                                     ziploc.lat.to_s, ziploc.lng.to_s, radius.to_s])
  end

  def self.near(zip, radius)
    ziploc = ZipLoc.find_by_zip(zip)

    # TODO: you need error handling if there is no zip code found...
    #  this is temporary...
    ziploc=ZipLoc.first unless ziploc

    includes([:theaters]).where(["sqrt(69.1*(theaters.latitude - :ziplat)*69.1*(theaters.latitude - :ziplat)
            + 69.1*(theaters.longitude - :ziplng)*69.1*(theaters.longitude - :ziplng)) < :rad",
                                 :ziplat=>ziploc.lat, :ziplng=>ziploc.lng, :rad=>radius])
  end


end

