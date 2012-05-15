class WelcomeController < ApplicationController
  layout false

  def index
    @user=current_user
    @invite_code=InviteCode.new
    @invite_request=InviteRequest.new
    @signed_in=user_signed_in?

    if @signed_in
      redirect_to users_dashboards_path
    end

  end
  
end