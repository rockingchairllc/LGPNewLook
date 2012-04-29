class InviteCode < ActiveRecord::Base
  has_many :users
  validates_presence_of :code
  validates_uniqueness_of :code
end
