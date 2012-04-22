class Authentication < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user_id, :provider, :provider_user_id, :provider_auth_id

  # only allow auth per user/provider
   # e.g. don't allow multiple auth from FB for same user.
  validates_uniqueness_of :provider_user_id, :scope=>[:user_id, :provider]
end
