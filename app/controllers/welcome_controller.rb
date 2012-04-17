class WelcomeController < ApplicationController
  layout false, {:only=>[:index, :verify_code]}

  def index
    @invite_code=InviteCode.new
    @signed_in=user_signed_in?
  end
  
end