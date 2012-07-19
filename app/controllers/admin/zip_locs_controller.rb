class Admin::ZipLocsController < AdminController
  # GET /zip_locs
  # GET /zip_locs.json
  def index
    @zip_locs = ZipLoc.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @zip_locs }
    end
  end

  # GET /zip_locs/1
  # GET /zip_locs/1.json
  def show
    @zip_loc = ZipLoc.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @zip_loc }
    end
  end

  # GET /zip_locs/new
  # GET /zip_locs/new.json
  def new
    @zip_loc = ZipLoc.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @zip_loc }
    end
  end

  # GET /zip_locs/1/edit
  def edit
    @zip_loc = ZipLoc.find(params[:id])
  end

  # POST /zip_locs
  # POST /zip_locs.json
  def create
    @zip_loc = ZipLoc.new(params[:zip_loc])

    respond_to do |format|
      if @zip_loc.save
        format.html { redirect_to admin_zip_loc_path(@zip_loc), notice: 'Zip loc was successfully created.' }
        format.json { render json: @zip_loc, status: :created, location: @zip_loc }
      else
        format.html { render action: "new" }
        format.json { render json: @zip_loc.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /zip_locs/1
  # PUT /zip_locs/1.json
  def update
    @zip_loc = ZipLoc.find(params[:id])

    respond_to do |format|
      if @zip_loc.update_attributes(params[:zip_loc])
        format.html { redirect_to admin_zip_loc_path(@zip_loc), notice: 'Zip loc was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @zip_loc.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /zip_locs/1
  # DELETE /zip_locs/1.json
  def destroy
    @zip_loc = ZipLoc.find(params[:id])
    @zip_loc.destroy

    respond_to do |format|
      format.html { redirect_to admin_zip_locs_path }
      format.json { head :no_content }
    end
  end
end
