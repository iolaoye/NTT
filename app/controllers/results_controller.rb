class ResultsController < ApplicationController
  # GET /results
  # GET /results.json
  def index
	@total_area = Field.find(session[:field_id]).field_area
    @project_name = Project.find(session[:project_id]).name
    @field_name = Field.find(session[:field_id]).field_name
	@scenario1 = 0
	@scenario2 = 0
	@scenario3 = 0
	@soil = "0"
		
	params[:button] == t("result.by_soil") ? @soil = params[:result4][:soil_id] : @soil = "0"
	if params[:result1] != nil
		if params[:result1][:scenario_id] != "" then
			@scenario1 = params[:result1][:scenario_id] 			
			@results1 = Result.select("results.*, descriptions.*").where(:field_id => session[:field_id], :scenario_id => params[:result1][:scenario_id], :soil_id => @soil).joins(:description)
		end
		if params[:result2][:scenario_id] != "" then
			@scenario2 = params[:result2][:scenario_id]
			@results2 = Result.select("results.*, descriptions.*").where(:field_id => session[:field_id], :scenario_id => params[:result2][:scenario_id], :soil_id => @soil).joins(:description)
		end
		if params[:result3][:scenario_id] != "" then
			@scenario3 = params[:result3][:scenario_id]
			@results3 = Result.select("results.*, descriptions.*").where(:field_id => session[:field_id], :scenario_id => params[:result3][:scenario_id], :soil_id => @soil).joins(:description)
		end
	end
   
    if params[:button] == t('result.graph') then
		render "charts"
	else
		respond_to do |format|
		  format.html # index.html.erb
		end
	end
  end

  # GET /results/1
  # GET /results/1.json
  def show
    @result = Result.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @result }
    end
  end

  # GET /results/new
  # GET /results/new.json
  def new
    @result = Result.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @result }
    end
  end

  # GET /results/1/edit
  def edit
    @result = Result.find(params[:id])
  end

  # POST /results
  # POST /results.json
  def create
    @result = Result.new(result_params)

    respond_to do |format|
      if @result.save
        format.html { redirect_to @result, notice: 'Result was successfully created.' }
        format.json { render json: @result, status: :created, location: @result }
      else
        format.html { render action: "new" }
        format.json { render json: @result.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /results/1
  # PATCH/PUT /results/1.json
  def update
  ooo
    @result = Result.find(params[:id])

    respond_to do |format|
      if @result.update_attributes(result_params)
        format.html { redirect_to @result, notice: 'Result was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @result.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /results/1
  # DELETE /results/1.json
  def destroy
    @result = Result.find(params[:id])
    @result.destroy

    respond_to do |format|
      format.html { redirect_to results_url }
      format.json { head :no_content }
    end
  end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def result_params
      params.require(:result).permit(:field_id, :scenario_id, :soil_id, :value, :watershed_id, :description_id, :ci_value)
    end
end
