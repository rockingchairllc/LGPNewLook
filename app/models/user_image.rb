class CustomProfilePicValidator < ActiveModel::Validator
  def validate(record)
    if record.is_profile_pic && UserImage.all(:conditions=>['user_id=? and is_profile_pic=true', record.user_id]).count > 0
      record.errors[:is_profile_pic] << 'Only one image can be a profile pic.'
    end
  end
  end

class UserImage < ActiveRecord::Base
  include ActiveModel::Validations
  validates_with CustomProfilePicValidator

  belongs_to :user
  has_attached_file :photo, 
  :styles => { :medium => "300x300>", :thumb => "100x100>", :tiny => "35x45" },
  :storage => :s3, 
  :s3_credentials => "#{Rails.root}/config/s3.yml", 
  :path => "user_photo/:id/:style/:basename.:extension"

  validates_presence_of :photo_file_name

  # attr_accessor :photo
  #:styles => { :thumb => "80x75" },
  #, :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",

end
