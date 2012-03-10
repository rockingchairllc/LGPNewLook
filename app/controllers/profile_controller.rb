class ProfileController < ApplicationController
  before_filter :authenticate_user!
  def profile
  end
end