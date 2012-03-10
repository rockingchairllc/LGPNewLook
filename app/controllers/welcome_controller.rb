class WelcomeController < ApplicationController
  layout false, {:only=>[:index,:signup]}
  def index
    
  end
  
  def verify_code
    @code=params[:code_value]
    if(@code=='popcorn')
      redirect_to signup_url
    elsif
      @results="You're not in"
    end
  end
  
  def signup
    
  end
end