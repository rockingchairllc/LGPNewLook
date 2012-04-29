
# invoked by secondary registration step.
class UsersJsonController < ApplicationController
  def update
    user=User.find(params[:id])

    # security check
    unless user.id==current_user.id
      return render :json => { :success=>false, :errors=>['you do not have permission to do this'] }
    end

    # fields we are allowed to update, with custom errors if not present...
    if params[:user][:firstname] && !params[:user][:firstname].blank?
      user.firstname=params[:user][:firstname]
    else
      user.errors[:firstname] << 'is required.'
    end

    if params[:user][:gender] && !params[:user][:gender].blank?
      user.gender=params[:user][:gender]
    else
      user.errors[:gender] << 'is required.'
    end

    if params[:user][:orientation] && !params[:user][:orientation].blank?
      user.orientation=params[:user][:orientation]
    else
      user.errors[:orientation] << 'is required.'
    end

    if params[:user][:zipcode] && !params[:user][:zipcode].blank?
      user.zipcode=params[:user][:zipcode]
    else
      user.errors[:zipcode] << 'is required.'
    end

    if params[:user]['birthdate(1i)'] && !params[:user]['birthdate(1i)'].blank?
      user.birthdate=Date.new(params[:user]['birthdate(1i)'].to_i,params[:user]['birthdate(2i)'].to_i,params[:user]['birthdate(3i)'].to_i)
    else
      user.errors[:birthdate] << 'is required.'
    end


    if user.errors.count == 0 && user.save
      return render :json => { :success=>true }
    else
      new_errors={}
      user.errors.each do |f,m|
        new_errors[f]=User.human_attribute_name(f) + ' ' + m
      end
      return render :json => { :success=>false, :errors=>new_errors }
    end

  end
end