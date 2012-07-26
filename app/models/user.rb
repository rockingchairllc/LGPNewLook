class User < ActiveRecord::Base
  has_many :authentications, :dependent => :destroy
  has_many :answers, :autosave => true
  has_many :questions, :through => :answers
  has_many :user_images, :dependent => :destroy
  has_one :profile_pic, :class_name => "UserImage", :conditions => {:is_profile_pic => true}
  has_many :watch_lists, :dependent => :destroy

  belongs_to :invite_code

  before_save :set_zip_lat_long

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,:registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :firstname, :password, :password_confirmation, :remember_me, :gender, :orientation,
                  :zipcode, :zipcode_longitude, :zipcode_latitude, :birthdate, :user_images_attributes
  accepts_nested_attributes_for :user_images
  
  # enable users to send messages using mailboxer
  acts_as_messageable

  # set user's lat and long on save
  def set_zip_lat_long
    if self.zipcode
      ziploc=ZipLoc.find_by_zip(self.zipcode)
      if ziploc
        self.zipcode_latitude=ziploc.lat
        self.zipcode_longitude=ziploc.lng
      else
        self.zipcode_latitude=nil
        self.zipcode_longitude=nil
      end
    end
  end

  def watchlist_movies
    watchlist = self.watch_lists
    watchlist_movies = Array.new
    watchlist.each do |watchlist_item|
      movie = Movie.find_by_id(watchlist_item.movie_id)
      watchlist_movies << movie
    end
    watchlist_movies
  end

  def watch_list_preferred_theaters(watch_list_id)
    watch_list = self.watch_lists.where("id = ?", watch_list_id).first
    theaters = []
    preferred_theaters = watch_list.watch_list_preferred_theaters
    preferred_theaters.each do |preferred_theater|
      theaters << Theater.find_by_id(preferred_theater.theater_id)
    end
    theaters
  end

  def self.near_no_watchlists(user,zip,radius)
    ziploc = ZipLoc.find_by_zip(zip)
    # zip code not in our database
    return [] unless ziploc

    distance="sqrt(69.1*(users.zipcode_latitude - " + ziploc.lat.to_s + ")*69.1*(users.zipcode_latitude - " + ziploc.lat.to_s +
      ") + 69.1*(users.zipcode_longitude - " + ziploc.lng.to_s + ")*69.1*(users.zipcode_longitude - " + ziploc.lng.to_s + "))"

    all(:include => [ :watch_lists ],
        :order=>[ distance ],
        :conditions=>[ distance + " < ? and users.id!=? and users.id not in ( select user_id from watch_lists )",radius, user.id] )

  end

  # if you pass movie_id, will filter for just that movie
  def self.near_watchlists(user, zip, radius, movie_id = nil)
    ziploc = ZipLoc.find_by_zip(zip)

    # zip code not in our database
    return [] unless ziploc

    distance="sqrt(69.1*(users.zipcode_latitude - " + ziploc.lat.to_s + ")*69.1*(users.zipcode_latitude - " + ziploc.lat.to_s +
      ") + 69.1*(users.zipcode_longitude - " + ziploc.lng.to_s + ")*69.1*(users.zipcode_longitude - " + ziploc.lng.to_s + "))"

    if movie_id
      all(:include=>[ :watch_lists ],
          :joins => [ :watch_lists ],
          :order=>[ distance ],
          :conditions=>[ distance + " < ? and watch_lists.movie_id=? and users.id!=?", radius, movie_id, user.id])
    else
      all(:include=>[ :watch_lists ],
          :joins => [ :watch_lists ],
          :order=>[ distance ],
          :conditions=>[ distance + " < ? and users.id!=?",radius, user.id] )
    end

  end

  # This is just place-holder, please implement the true things.
  def near_buddies(limit = 8)
    # all users with a watchlist ( not self ) -- sample selection of LIMIT
    WatchList.all.collect { |w| w.user }.reject { |user| user == self }.uniq.sample(limit)
  end

  def get_gender
    gender.present?? gender.downcase : 'male'
  end
end

