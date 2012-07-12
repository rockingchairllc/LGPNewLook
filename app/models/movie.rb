class Movie < ActiveRecord::Base
  has_many :schedules, :inverse_of => :movie
  has_many :theaters, :through => :schedules, :uniq => true
  has_many :watch_lists
  has_many :watchlisters, :source => :user, :through => :watch_lists
  has_attached_file :poster, :storage => :s3, :s3_credentials => "#{Rails.root}/config/s3.yml", :path => "movieposters/:id/:filename"

  def self.popular(zipcode, radius=50, count=3)
    return unless zipcode
    m=Movie.near(zipcode, radius)
    m.sort_by! { |m| m.watch_lists.count }.reverse!
    m=m[0..count-1]
    m
  end

  def self.near(zip, radius, movie_id=nil, search=nil)
    ziploc = ZipLoc.find_by_zip(zip)

    # zip code not in our database
    return [] unless ziploc

    distance="sqrt(69.1*(theaters.latitude - " + ziploc.lat.to_s + ")*69.1*(theaters.latitude - " + ziploc.lat.to_s + ") + 69.1*(theaters.longitude - " + ziploc.lng.to_s + ")*69.1*(theaters.longitude - " + ziploc.lng.to_s + "))"

    if movie_id && search
      all(:include=>[ :theaters ],
          :order=>[ distance ],
          :conditions=>[ distance + " < ? and movies.id=? and lower(movies.title) like ?", radius, movie_id, '%' + search.downcase + '%' ])
    elsif movie_id
      all(:include=>[ :theaters ],
          :order=>[ distance ],
          :conditions=>[ distance + " < ? and movies.id=?", radius, movie_id])
    elsif search
      all(:include=>[ :theaters ],
          :order=>[ distance ],
          :conditions=>[ distance + " < ? and lower(movies.title) like ?", radius, '%' + search.downcase + '%' ])
    else
      all(:include=>[ :theaters ],
          :order=>[ "movies.release_dt desc, movies.title, " + distance ],
          :conditions=>[ distance + " < ?",radius] )
    end

  end


end

