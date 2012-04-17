class InviteRequestsController < ApplicationController

  def create
    unless params[:invite_request]
      render :json => { :success=> false, :errors=>['invite request is required']}
      return
    end

    @ir=InviteRequest.new(params[:invite_request])

    if(@ir.save)
      render :json => { :success=>true, :message=>'invite request processed', :errors=>[] }
    else
      new_errors={}
      @ir.errors.each do |f,m|
        new_errors[f]=InviteRequest.human_attribute_name(f) + ' ' + m
      end
      render :json => { :success=>false, :errors=>new_errors }
    end
  end

end
