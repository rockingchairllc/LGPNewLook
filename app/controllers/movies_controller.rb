class MoviesController < ApplicationController
  # GET /movies
  # GET /movies.json
  def index
    
    # old index page -- commented out to try new view
    #@movies = Movie.all

    # new code for movies list that will limit to zip radius
    @user = User.find(current_user.id)
    @z1 = ZipLoc.where("zip = ?", @user.zipcode).first
    @radius = 5

    # uses approach of first finding theaters, then listing movies, but isn't finished
    # @theaters = Theater.find(:all,
    #                          :conditions => ["miles_between_lat_long(?, ?,
    #                            latitude, longitude) < ?",
    #                            @z1.lat, @z1.lng, @radius])

    # uses left outer join approach to return list of movies
    @movies = Movie.includes([:theaters]).find(:all,
                                               :conditions => ["miles_between_lat_long(?, ?,
                                                theaters.latitude, theaters.longitude) < ?",
                                                @z1.lat, @z1.lng, @radius])
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @movies }
    end
  end

  # GET /movies/1
  # GET /movies/1.json
  def show
    @movie = Movie.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @movie }
    end
  end

  
  # GET /movies/new
  # GET /movies/new.json
  def new
    @movie = Movie.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @movie }
    end
  end

  # GET /movies/1/edit
  def edit
    @movie = Movie.find(params[:id])
  end

  # POST /movies
  # POST /movies.json
  def create
    @movie = Movie.new(params[:movie])

    respond_to do |format|
      if @movie.save
        format.html { redirect_to @movie, notice: 'Movie was successfully created.' }
        format.json { render json: @movie, status: :created, location: @movie }
      else
        format.html { render action: "new" }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /movies/1
  # PUT /movies/1.json
  def update
    @movie = Movie.find(params[:id])

    respond_to do |format|
      if @movie.update_attributes(params[:movie])
        format.html { redirect_to @movie, notice: 'Movie was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/1
  # DELETE /movies/1.json
  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy

    respond_to do |format|
      format.html { redirect_to movies_url }
      format.json { head :no_content }
    end
  end
end
