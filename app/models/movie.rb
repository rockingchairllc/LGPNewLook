class Movie < ActiveRecord::Base
  has_many :schedules, :inverse_of => :movie
  has_many :theaters, :through => :schedules, :uniq => true
  has_many :watch_lists
  has_attached_file :poster, :storage => :s3, :s3_credentials => "#{Rails.root}/config/s3.yml", :path => "movieposters/:id/:filename"


  def nearbytheaters(zip, radius)
    Theaters.near(zip, radius)
  end
  
end

