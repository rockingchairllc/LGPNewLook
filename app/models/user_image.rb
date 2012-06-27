require 'uri'
require 'net/http'
require 'net/https'

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
  :styles => { :medium => "", :thumb => "", :small_thumb => "", :tiny => "" },
  :storage => :s3, 
  :s3_credentials => "#{Rails.root}/config/s3.yml", 
  :path => "user_photo/:id/:style/:basename.:extension",
  :processor => "rmagick",
  :convert_options => {
    :medium       => "-resize 300x300^ -gravity Center -crop 300x300+0+0",
    :thumb        => "-resize 90x100^ -gravity Center -crop 90x100+0+0",
    :small_thumb  => "-resize 60x70^ -gravity Center -crop 60x70+0+0",
    :tiny         => "-resize 35x45^ -gravity Center -crop 35x45+0+0"
  }

  validates_presence_of :photo_file_name

  def picture_from_url(url)

    uri=URI.parse(url)

    logger.debug "downloading file: " + uri.inspect

    resp=fetch(uri)
    logger.debug 'response: ' + resp.inspect

    out_file = Tempfile.new(['temp_image', '.jpg'])
    out_file.binmode
    out_file.write(resp.body)
    out_file.flush

    out_file.rewind

    self.photo=out_file
  end

  private
  # this handles up to 10 redirects ( which FB does for images )
  def fetch(uri, limit = 10)
    raise ArgumentError, 'HTTP redirect too deep' if limit == 0

    logger.debug 'downloading uri: ' + uri.inspect

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl=true if uri.port==443
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    response=http.get(uri.request_uri)

    case response
      when Net::HTTPSuccess     then response
      when Net::HTTPRedirection then fetch(URI.parse(response['location']), limit - 1)
      else
        response.error!
    end
  end
end
