class InviteRequest < ActiveRecord::Base
  validates_presence_of :email, :zip_code
  validates_uniqueness_of :email

  HUMAN_ATTRIBUTES = { :email => "Email", :zip_code=> "Zip code", :comments=>"Comments" }

  def self.human_attribute_name(attr, options={} )
    HUMAN_ATTRIBUTES[attr.to_sym] || super
  end

end
