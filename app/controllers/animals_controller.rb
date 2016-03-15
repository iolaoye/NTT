class AnimalsController < ApplicationController
  # GET /animals
  # GET /animals.json
  def index
    @animals = Animal.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @animals }
    end
  end

  # GET /animals/1
  # GET /animals/1.json
  def show
    @animal = Animal.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @animal }
    end
  end

  # GET /animals/new
  # GET /animals/new.json
  def new
    @animal = Animal.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @animal }
    end
  end

  # GET /animals/1/edit
  def edit
    @animal = Animal.find(params[:id])
  end

  # POST /animals
  # POST /animals.json
  def create
    @animal = Animal.new(animal_params)

    respond_to do |format|
      if @animal.save
        format.html { redirect_to @animal, notice: 'Animal was successfully created.' }
        format.json { render json: @animal, status: :created, location: @animal }
      else
        format.html { render action: "new" }
        format.json { render json: @animal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /animals/1
  # PATCH/PUT /animals/1.json
  def update
    @animal = Animal.find(params[:id])

    respond_to do |format|
      if @animal.update_attributes(animal_params)
        format.html { redirect_to @animal, notice: 'Animal was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @animal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /animals/1
  # DELETE /animals/1.json
  def destroy
    @animal = Animal.find(params[:id])
    @animal.destroy

    respond_to do |format|
      format.html { redirect_to animals_url }
      format.json { head :no_content }
    end
  end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def animal_params
      params.require(:animal).permit(:apex_code, :name, :status)
    end
end
