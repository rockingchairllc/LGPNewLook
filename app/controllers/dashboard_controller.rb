class DashboardController < ApplicationController
  before_filter :authenticate_user!
  def dashboard
    @user=User.find(current_user.id)

    # stuff for profile.

  end
end