class AdminController < ApplicationController
  layout 'application'
  before_filter :authorize_admin

  def authorize_admin
    unless current_user && current_user.is_admin
      redirect_to root_url
    end
  end
end
