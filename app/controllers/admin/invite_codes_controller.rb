class Admin::InviteCodesController < AdminController

  def index
    @invite_codes=InviteCode.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @invite_codes }
    end
  end

  def show
    @invite_code = InviteCode.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @invite_code }
    end
  end

  def new
    @invite_code = InviteCode.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @invite_code }
    end
  end

  def edit
    @invite_code = InviteCode.find(params[:id])
  end

  def create
    @invite_code = InviteCode.new(params[:invite_code])

    respond_to do |format|
      if @invite_code.save
        format.html { redirect_to admin_invite_code_path(@invite_code), notice: 'Invite Code was successfully created.' }
        format.json { render json: @invite_code, status: :created, location: @invite_code }
      else
        format.html { render action: "new" }
        format.json { render json: @invite_code.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @invite_code = InviteCode.find(params[:id])

    respond_to do |format|
      if @invite_code.update_attributes(params[:invite_code])
        format.html { redirect_to admin_invite_code_path(@invite_code), notice: 'Invite Code was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @invite_code.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @invite_code=InviteCode.find(params[:id])
    @invite_code.destroy

    respond_to do |format|
      format.html { redirect_to admin_invite_codes_path }
      format.json { head :no_content }
    end
  end
end
