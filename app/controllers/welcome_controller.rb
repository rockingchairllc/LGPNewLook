class WelcomeController < ApplicationController
  layout false, {:only=>[:index, :verify_code]}

  def index
    @user=current_user
    @invite_code=InviteCode.new
    @invite_request=InviteRequest.new
    @signed_in=user_signed_in?

    if @signed_in
      redirect_to user_path(@current_user.id)
    end

  end
  
end