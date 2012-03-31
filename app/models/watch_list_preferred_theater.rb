class WatchListPreferredTheater < ActiveRecord::Base
  belongs_to :watch_list
  belongs_to :theater

  validates_presence_of :watch_list_id, :theater_id
  validates_uniqueness_of :theater_id, :scope=>:watch_list_id
end
