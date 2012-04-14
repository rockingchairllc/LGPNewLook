class AdminController < ActionController::Base
  layout 'application'
  before_filter :authorize_admin

  def authorize_admin
    if current_user && current_user.is_admin
      true
    else
      false
    end
  end
end
