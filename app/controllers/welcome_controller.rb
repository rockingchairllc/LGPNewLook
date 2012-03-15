class WelcomeController < ApplicationController
  layout false, {:only=>[:index,:signup]}
  def index
    @signed_in=user_signed_in?
  end
  
  def verify_code
    @code=params[:code_value]
    if(@code=='popcorn')
      redirect_to "/users/login"
    elsif
      @results="You're not in"
    end
  end
  
  def signup
    
  end
end