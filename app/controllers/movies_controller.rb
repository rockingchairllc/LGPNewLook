class MoviesController < ApplicationController

  def index
    @user=User.find(current_user.id)
    @watch_list=@user.watch_lists

    @param_miles=params[:miles] || 20
    @param_zip=params[:zip] || @user.zipcode

    # TODO: handle error for non-integer param
    @zip=ZipLoc.find_by_zip(@param_zip.to_i)

    unless @zip
      @zip=ZipLoc.first
    end

    @movies=@zip.movies_and_theaters_near_zip(@param_miles)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @movies }
    end
  end

  def show
    @movie = Movie.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @movie }
    end
  end
