class User < ActiveRecord::Base
  has_many :answers
  has_many :user_images
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,:registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :firstname, :password, :password_confirmation, :remember_me, :gender, :orientation, :zipcode, :user_images_attributes
  accepts_nested_attributes_for :user_images
  
end
