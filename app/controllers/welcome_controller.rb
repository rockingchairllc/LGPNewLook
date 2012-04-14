class WelcomeController < ApplicationController
  layout false, {:only=>[:index, :verify_code]}

  def index
    @signed_in=user_signed_in?
  end
  
  def verify_code
    @code=params[:code_value]
    if(InviteCode.find_by_code(@code))
      redirect_to new_user_registration_path
    elsif
      @results="You're not in"
    end
  end
  
  def signup
    
  end
end