class WatchList < ActiveRecord::Base
  belongs_to :user
  belongs_to :movie
  has_many :watch_list_preferred_theaters

  validates_presence_of :user_id, :movie_id
  validates_uniqueness_of :movie_id, :scope=>:user_id
end
