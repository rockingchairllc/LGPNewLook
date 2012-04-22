class User < ActiveRecord::Base
  has_many :authentications
  has_many :answers, :autosave => true
  has_many :questions, :through => :answers
  has_many :user_images
  has_one :profile_pic, :class_name => "UserImage", :conditions => {:is_profile_pic => true}
  has_many :watch_lists

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,:registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :firstname, :password, :password_confirmation, :remember_me, :gender, :orientation, :zipcode, :birthdate, :user_images_attributes
  accepts_nested_attributes_for :user_images
  
end

