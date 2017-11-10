class SitesController < ApplicationController
  # GET /sites
  # GET /sites.json

  
  

  def index
    @sites = Site.where(:field_id => params[:field_id])
    @field = Field.find(params[:field_id])
    @project = Project.find(params[:project_id])
    
	
	add_breadcrumb t('menu.utility_file')
	add_breadcrumb t('menu.site')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sites }
    end
  end

  # GET /sites/1
  # GET /sites/1.json
  def show
    @site = Site.find(params[:id])
    @field = Field.find(params[:field_id])
    @project = Project.find(params[:project_id])
	add_breadcrumb t('menu.utility_file')
	add_breadcrumb t('menu.site'), controller: "sites", action: "index"
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @site }
    end
  end

  # GET /sites/new
  # GET /sites/new.json
  def new
    @site = Site.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @site }
    end
  end

  # GET /sites/1/edit
  def edit
    @site = Site.find(params[:id])
    @field = Field.find(params[:field_id])
    @project = Project.find(params[:project_id])
	add_breadcrumb t('menu.utility_file')
	add_breadcrumb t('menu.site'), controller: "sites", action: "index"
	add_breadcrumb t('general.editing') + " " + t('menu.site')
  end

  # POST /sites
  # POST /sites.json
  def create
    @site = Site.new(site_params)

    respond_to do |format|
      if @site.save
        format.html { redirect_to sites_path(session[:id => :field_id]), notice: t('models.site') + "" + t('notices.created') }
        format.json { render json: @site, status: :created, location: @site }
      else
        format.html { render action: "new" }
        format.json { render json: @site.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sites/1
  # PATCH/PUT /sites/1.json
  def update
    @site = Site.find(params[:id])

    respond_to do |format|
      if @site.update_attributes(site_params)
        format.html { redirect_to project_field_sites_url, notice: t('models.site') + "" + t('notices.updated') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @site.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sites/1
  # DELETE /sites/1.json
  def destroy
    @site = Site.find(params[:id])
    @site.destroy

    respond_to do |format|
      format.html { redirect_to project_field_sites_url, notice: t('models.site') + "" + t('notices.deleted') }
      format.json { head :no_content }
    end
  end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def site_params
      params.require(:site).permit(:apm, :co2x, :cqnx, :elev, :fir0, :rfnx, :unr, :upr, :xlog, :ylat)
    end
end
