class BmpsublistsController < ApplicationController
  # GET /bmpsublists
  # GET /bmpsublists.json
  def index
    #@bmpsublists = Bmpsublist.where(:bmplist_id => params[:bmplist_id])
    @bmpsublists = Bmpsublist.where(:status => true)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bmpsublists }
    end
  end

  # GET /bmpsublists/1
  # GET /bmpsublists/1.json
  def show
    @bmpsublist = Bmpsublist.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @bmpsublist }
    end
  end

  # GET /bmpsublists/new
  # GET /bmpsublists/new.json
  def new
    @bmpsublist = Bmpsublist.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @bmpsublist }
    end
  end

  # GET /bmpsublists/1/edit
  def edit
    @bmpsublist = Bmpsublist.find(params[:id])
  end

  # POST /bmpsublists
  # POST /bmpsublists.json
  def create
   @bmpsublist = Bmpsublist.new(bmpsublist_params)

    respond_to do |format|
      if @bmpsublist.save
        format.html { redirect_to @bmpsublist, notice: 'Bmpsublist was successfully created.' }
        format.json { render json: @bmpsublist, status: :created, location: @bmpsublist }
      else
        format.html { render action: "new" }
        format.json { render json: @bmpsublist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bmpsublists/1
  # PATCH/PUT /bmpsublists/1.json
  def update
    @bmpsublist = Bmpsublist.find(params[:id])

    respond_to do |format|
      if @bmpsublist.update_attributes(bmpsublist_params)
        format.html { redirect_to @bmpsublist, notice: 'Bmpsublist was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @bmpsublist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bmpsublists/1
  # DELETE /bmpsublists/1.json
  def destroy
    @bmpsublist = Bmpsublist.find(params[:id])
    @bmpsublist.destroy

    respond_to do |format|
      format.html { redirect_to bmpsublists_url }
      format.json { head :no_content }
    end
  end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def bmpsublist_params
      params.require(:bmpsublist).permit(:name, :status, :bmplist_id, :spanish_name)
    end
end
