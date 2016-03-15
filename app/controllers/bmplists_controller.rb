class BmplistsController < ApplicationController
  # GET /bmplists
  # GET /bmplists.json
  def index
    @bmplists = Bmplist.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bmplists }
    end
  end

  # GET /bmplists/1
  # GET /bmplists/1.json
  def show
    @bmplist = Bmplist.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @bmplist }
    end
  end

  # GET /bmplists/new
  # GET /bmplists/new.json
  def new
    @bmplist = Bmplist.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @bmplist }
    end
  end

  # GET /bmplists/1/edit
  def edit
    @bmplist = Bmplist.find(params[:id])
  end

  # POST /bmplists
  # POST /bmplists.json
  def create
    @bmplist = Bmplist.new(bmplist_params)

    respond_to do |format|
      if @bmplist.save
        format.html { redirect_to @bmplist, notice: 'Bmplist was successfully created.' }
        format.json { render json: @bmplist, status: :created, location: @bmplist }
      else
        format.html { render action: "new" }
        format.json { render json: @bmplist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bmplists/1
  # PATCH/PUT /bmplists/1.json
  def update
    @bmplist = Bmplist.find(params[:id])

    respond_to do |format|
      if @bmplist.update_attributes(bmplist_params)
        format.html { redirect_to @bmplist, notice: 'Bmplist was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @bmplist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bmplists/1
  # DELETE /bmplists/1.json
  def destroy
    @bmplist = Bmplist.find(params[:id])
    @bmplist.destroy

    respond_to do |format|
      format.html { redirect_to bmplists_url }
      format.json { head :no_content }
    end
  end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def bmplist_params
      params.require(:bmplist).permit(:name)
    end
end
