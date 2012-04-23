class InviteCodesController < ApplicationController

  # use this method to check if code is valid
  def create
    unless params[:invite_code] && params[:invite_code][:code] && !params[:invite_code][:code].blank?
      render :json => { :success=> false, :errors=>['invite code is required']}
      return
    end

    if(InviteCode.find_by_code(params[:invite_code][:code]))
      cookies[:invite_code]=params[:invite_code][:code]
      render :json => { :success=>true, :message=>'valid invite code', :errors=>[] }
    else
      render :json => { :success=>false, :errors=>['invalid invite code'] }
    end
  end

end
