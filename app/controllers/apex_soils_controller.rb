﻿class ApexSoilsController < ApplicationController
################################  INDEX   #################################
  # GET /soils
  # GET /soils.json
  def index
    #@field = Field.find(params[:field_id])
    #@project = Project.find(params[:project_id])
    @soils = @field.soils
    add_breadcrumb t('menu.utility_file')
    add_breadcrumb t('menu.soils')
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @soils }
    end
  end

  # GET /soils/1
  # GET /soils/1.json
  def show
    #@project = Project.find(params[:project_id])
    @soil = Soil.find(params[:id])
    #@field = Field.find(params[:field_id])
    @location = Location.where(:project_id => params[:project_id])
    add_breadcrumb t('menu.utility_file')
    add_breadcrumb t('menu.soils'), controller: "apex_soils", action: "index"
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @soil }
    end
  end

  # GET /soils/new
  # GET /soils/new.json
  def new
    @soil = Soil.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @soil }
    end
  end

  # GET /soils/1/edit
  def edit
    #@project = Project.find(params[:project_id])
    @soil = Soil.find(params[:id])
    #@field = Field.find(params[:field_id])
    @location = Location.where(:project_id => params[:project_id])
  	add_breadcrumb t('menu.utility_file')
  	add_breadcrumb t('menu.soils'), controller: "apex_soils", action: "index"
  	add_breadcrumb t('general.editing') + " " + t('menu.soils')
  end

  # POST /soils
  # POST /soils.json
  def create
    @soil = Soil.new(soil_params)
    respond_to do |format|
      if @soil.save
        format.html { redirect_to @soil, notice: t('models.soil') + "" + t('notices.created') }
        format.json { render json: @soil, status: :created, location: @soil }
      else
        format.html { render action: "new" }
        format.json { render json: @soil.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /soils/1
  # PATCH/PUT /soils/1.json
  def update
    @soil = Soil.find(params[:id])
    respond_to do |format|
      if @soil.update_attributes(soil_params)
        format.html { redirect_to apex_soils_path, notice: t('models.soil') + "" + t('notices.updated') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @soil.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /soils/1
  # DELETE /soils/1.json
  def destroy
    @soil = Soil.find(params[:id])
    @soil.destroy
    respond_to do |format|
      format.html { redirect_to list_soil_path(@soil.field_id) }
      format.json { head :no_content }
    end
  end

  private
    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def soil_params
      params.require(:soil).permit(:albedo, :drainage_id, :field_id, :group, :key, :name, :percentage, :selected, :slope, :symbol, :ffc, :wtmn, :wtmx, :wtbl, :gwst, :gwmx,
	  :rft, :rfpk, :tsla, :xids, :rtn1, :xidk, :zqt, :zf, :ztk, :fbm, :fhp )
    end
end
