class ProfileController < ApplicationController
  before_filter :authenticate_user!
  def profile
    @user=User.find(current_user.id)
    @watch_list=@user.watch_lists
  end
end