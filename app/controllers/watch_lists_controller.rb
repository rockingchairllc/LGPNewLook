class WatchListsController < ApplicationController
  # TODO:  temp remove --- not logged in
  # before_filter :authenticate_user!
  def index

  end


  # only implemented json handler
  def create
    uid=params[:user_id]
    movie_id=params[:movie_id]

    # TODO: do you want to enable security?  can a user add a movie to another user's watchlist?
    # optional --- example...
    #unless current_user.id == uid.to_i
    #  render :json => { :success => false, :errors=>['not authorized'] }
    #  return
    #end

    wl=WatchList.new(:user_id=>uid, :movie_id=>movie_id)

    respond_to do |format|
      format.html { # no implementation -- create view if needed
      }
      format.json {
        if wl.save
          render :json => { :success => true }
          return
        else
          render :json => {:success => false, :errors=>wl.errors }
          return
        end
      }
      end
  end

  def destroy
    uid=params[:user_id]
    movie_id=params[:movie_id]

    # TODO: same comment as above for security

    # make sure the watchlist item exists.
    wl=WatchList.find_by_user_id_and_movie_id(uid,movie_id)
    unless wl
      respond_to do |format|
        format.html { }
        format.json {
          render :json => { :success => false, :errors=>['not found'] }
          return
        }
      end
    end

    respond_to do |format|
      format.html { }
      format.json {
        if wl.destroy
          render :json => { :success => true }
          return
        else
          render :json => {:success => false, :errors=>wl.errors }
          return
        end
      }
    end

  end
end