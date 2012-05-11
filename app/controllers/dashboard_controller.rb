class DashboardController < ApplicationController
  before_filter :authenticate_user!
  def index
    @user=User.find(current_user.id)

    # stuff for profile.

  end
end