class ZipLoc < ActiveRecord::Base

  # matt- zip code should not be an integer -- lots of zip codes start with a 0
  validates_presence_of :zip, :lat, :lng
  validates_uniqueness_of :zip

  # veesh - will remove this function later just saving it in case anything breaks
  def movies_and_theaters_near_zip(radius_in_miles)
    s_function='miles_between_lat_long(' + self.lat.to_s + ',' + self.lng.to_s + ',theaters.latitude,theaters.longitude)'
    Movie.all(:include=>[:theaters], :joins=>[:theaters], :conditions=> s_function + '<' + radius_in_miles.to_s, :order=>s_function)
  end

end
