class FacebookInterestsUsers < ActiveRecord::Base
  belongs_to :facebook_interest
  belongs_to :user
  validates_presence_of :user_id
  validates_presence_of :facebook_interest_id
end
