class WelcomeController < ApplicationController
  layout false, {:only=>[:index, :verify_code]}

  def index
    @invite_code=InviteCode.new
    @invite_request=InviteRequest.new
    @signed_in=user_signed_in?
  end
  
end