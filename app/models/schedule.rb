class Schedule < ActiveRecord::Base
  belongs_to :theater, :inverse_of => :schedules, :dependent => :destroy
  belongs_to :movie, :inverse_of => :schedules, :dependent => :destroy
end
