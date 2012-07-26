class FacebookInterest < ActiveRecord::Base
  has_many :facebook_interests_users, :class_name=>'FacebookInterestsUsers', :foreign_key => 'facebook_interest_id', :dependent=>:destroy
  has_many :users, :through=>:facebook_interests_users

  validates_presence_of :identifier
  validates_uniqueness_of :identifier
end
