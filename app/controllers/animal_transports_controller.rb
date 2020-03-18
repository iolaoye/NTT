class AnimalTransportsController < ApplicationController
  #before_action :set_params

  def set_params
    @field = Field.find(params[:field_id])
    @project = Project.find(params[:project_id])
    @scenario = Scenario.find(params[:scenario_id])
  end

  def index
    @animal_transports = AnimalTransport.where(:scenario_id => params[:scenario_id])
    add_breadcrumb 'Aplcat'
    add_breadcrumb 'Animal Transport'
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @animal_transports }
    end
  end

  def show
    @animal_transport = AnimalTransport.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @animal_transport }
    end
  end

  # GET /animal_transport/new
  # GET /animal_transport/new.json
  def new
    @animal_transport = AnimalTransport.new
    @categories = Category.where(:animal_transport_id => @animal_transport.id)
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @animal_transport }
    end
  end

  def edit
    @animal_transport = AnimalTransport.find(params[:id])
    @categories = Category.where(:animal_transport_id => @animal_transport.id)
  end

  # POST /animal_transport
  # POST /animal_transport.json
  def create
    @animal_transport = AnimalTransport.new(animal_transport_params)
    @animal_transport.scenario_id = params[:scenario_id]
    respond_to do |format|
      if @animal_transport.save
        if @animal_transport.categories_slaug != nil
          for i in 1..@animal_transport.categories_slaug
            new_cat = Category.new
            new_cat.animal_transport_id = @animal_transport.id
            new_cat.weight
            new_cat.animals
            if !new_cat.save 
              format.html { render action: "new" }
              format.json { render json: @animal_transport.errors, status: :unprocessable_entity }
            end
          end
        end
        format.html { redirect_to project_field_scenario_animal_transports_path(@project, @field, @scenario), notice: 'animal_transport was added successfully.' }
        format.json { render json: @animal_transport, status: :created, location: @animal_transport }
      else
        format.html { render action: "new" }
        format.json { render json: @animal_transport.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /animal_transport/1
  # PATCH/PUT /animal_transport/1.json
  def update
    @animal_transport = AnimalTransport.find(params[:id])
    respond_to do |format|
      if @animal_transport.update_attributes(animal_transport_params)
        #delete all of the categories for this animal transport and create them again
        categories = Category.where(:animal_transport_id => @animal_transport.id)
        categories.delete_all
        if @animal_transport.categories_slaug != nil
          for i in 1..@animal_transport.categories_slaug
            new_cat = Category.new
            new_cat.animal_transport_id = @animal_transport.id
            weight_symbol = ("weight" + i.to_s).to_sym
            animals_symbol = ("animals" + i.to_s).to_sym
            new_cat.weight = params[weight_symbol]
            new_cat.animals = params[animals_symbol]
            if !new_cat.save 
              format.html { render action: "new" }
              format.json { render json: @animal_transport.errors, status: :unprocessable_entity }
            end
          end
        end
        format.html { redirect_to project_field_scenario_animal_transports_path(@project, @field, @scenario), notice: 'animal_transport was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @animal_transport.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /animal_transport/1
  # DELETE /animal_transport/1.json
  def destroy
    @animal_transport = AnimalTransport.find(params[:id])
    @animal_transport.destroy

    respond_to do |format|
      format.html { redirect_to project_field_scenario_animal_transports_path(@project, @field, @scenario) }
      format.json { head :no_content }
    end
  end

  private

  def animal_transport_params
    params.require(:animal_transport).permit(:freq_trip, :cattle_pro, :purpose, :trans, :categories_trans, :avg_marweight, :num_animal, :categories_slaug, :mortality_rate, :distance, :trailer_id, :truck_id, :fuel_id, :same_vehicle, :loading, :carcass, :boneless_beef)
  end

end
