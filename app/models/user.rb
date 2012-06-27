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

  def watch_list_preferred_theaters(watch_list_id)
    watch_list = self.watch_lists.where("id = ?", watch_list_id).first
    theaters = []
    preferred_theaters = watch_list.watch_list_preferred_theaters
    preferred_theaters.each do |preferred_theater|
      theaters << Theater.find_by_id(preferred_theater.theater_id)
    end
    theaters
  end

  # This is just place-holder, please implement the true things.
  def near_buddies(limit = 8)
    User.all.reject { |user| user == self }.sample(limit)
  end

  def get_gender
    gender.present?? gender.downcase : 'male'
  end
end

