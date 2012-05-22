class User < ActiveRecord::Base
  has_many :authentications, :dependent => :destroy
  has_many :answers, :autosave => true
  has_many :questions, :through => :answers
  has_many :user_images, :dependent => :destroy
  has_one :profile_pic, :class_name => "UserImage", :conditions => {:is_profile_pic => true}
  has_many :watch_lists, :dependent => :destroy

  belongs_to :invite_code

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,:registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :firstname, :password, :password_confirmation, :remember_me, :gender, :orientation, :zipcode, :birthdate, :user_images_attributes
  accepts_nested_attributes_for :user_images
  
  # enable users to send messages using mailboxer
  acts_as_messageable

  def watchlist_movies
    watchlist = self.watch_lists
    watchlist = self.watch_lists
    watchlist_movies = Array.new
    watchlist.each do |watchlist_item|
      movie = Movie.find_by_id(watchlist_item.movie_id)
      watchlist_movies << movie
    end
    watchlist_movies
  end

  def watch_list_preferred_theaters
    watch_lists = self.watch_lists
    wl_preferred_theaters = []
    watch_lists.each do |watch_list|
      preferred_theaters = watch_list.watch_list_preferred_theaters
      preferred_theaters.each do |preferred_theater|
        wl_preferred_theaters << preferred_theater
      end
    end
    wl_preferred_theaters
  end
  
end

