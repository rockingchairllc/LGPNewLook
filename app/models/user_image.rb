class UserImage < ActiveRecord::Base
  belongs_to :user
  has_attached_file :photo, 
  :styles => { :medium => "300x300>", :thumb => "100x100>" },
  :storage => :s3, 
  :s3_credentials => "#{Rails.root}/config/s3.yml", 
  :path => "user_photo/:id/:style/:basename.:extension"

  # attr_accessor :photo
  #:styles => { :thumb => "80x75" },
  #, :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
  
end