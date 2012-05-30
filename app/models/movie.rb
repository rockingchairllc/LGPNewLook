class Movie < ActiveRecord::Base
  has_many :schedules, :inverse_of => :movie
  has_many :theaters, :through => :schedules, :uniq => true
  has_many :watch_lists
  has_many :watchlisters, :source => :user, :through => :watch_lists
  has_attached_file :poster, :storage => :s3, :s3_credentials => "#{Rails.root}/config/s3.yml", :path => "movieposters/:id/:filename"

  def self.near(zip, radius, movie_id=nil)
    ziploc = ZipLoc.find_by_zip(zip)

    # zip code not in our database
    return [] unless ziploc

    distance="sqrt(69.1*(theaters.latitude - " + ziploc.lat.to_s + ")*69.1*(theaters.latitude - " + ziploc.lat.to_s + ") + 69.1*(theaters.longitude - " + ziploc.lng.to_s + ")*69.1*(theaters.longitude - " + ziploc.lng.to_s + "))"

    if movie_id
      all(:include=>[ :theaters ],
          :order=>[ distance ],
          :conditions=>[ distance + " < ? and movies.id=?", radius, movie_id])
    else
      all(:include=>[ :theaters ],
          :order=>[ "movies.release_dt desc, movies.title, " + distance ],
          :conditions=>[ distance + " < ?",radius] )
    end

  end


end

