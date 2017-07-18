class DrainagesController < ApplicationController
  # GET /drainages
  # GET /drainages.json
  def index
    @drainages = Drainage.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @drainages }
    end
  end

  # GET /drainages/1
  # GET /drainages/1.json
  def show
    @drainage = Drainage.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @drainage }
    end
  end

  # GET /drainages/new
  # GET /drainages/new.json
  def new
    @drainage = Drainage.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @drainage }
    end
  end

  # GET /drainages/1/edit
  def edit
    @drainage = Drainage.find(params[:id])
  end

  # POST /drainages
  # POST /drainages.json
  def create
    @drainage = Drainage.new(drainage_params)

    respond_to do |format|
      if @drainage.save
        format.html { redirect_to @drainage, notice: 'Drainage was successfully created.' }
        format.json { render json: @drainage, status: :created, location: @drainage }
      else
        format.html { render action: "new" }
        format.json { render json: @drainage.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /drainages/1
  # PATCH/PUT /drainages/1.json
  def update
    @drainage = Drainage.find(params[:id])

    respond_to do |format|
      if @drainage.update_attributes(drainage_params)
        format.html { redirect_to @drainage, notice: 'Drainage was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @drainage.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /drainages/1
  # DELETE /drainages/1.json
  def destroy
    @drainage = Drainage.find(params[:id])
    @drainage.destroy

    respond_to do |format|
      format.html { redirect_to drainages_url }
      format.json { head :no_content }
    end
  end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def drainage_params
      params.require(:drainage).permit(:self_id, :name, :wtbl, :wtmn, :wtmx, :zqt, :ztk)
    end
end
