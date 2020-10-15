class FemFeedsController < ApplicationController
  #before_action :set_fem_feed, only: [:show, :edit, :update, :destroy]
  include FemHelper
  # GET /fem_feeds
  def index
    session[:simulation] = "fem"
    @fem_feeds = FemFeed.where(:project_id => @project.id).order(:name)
    if @fem_feeds == [] then
      load_feeds
      @fem_feeds = FemFeed.where(:project_id => @project.id).order(:name)    
    end
    if params[:field_id] != nil then @field = Field.find(params[:field_id]) end
  end

  # GET /fem_feeds/1
  def show
  end

  # GET /fem_feeds/new
  def new
    @fem_feed = FemFeed.new
  end

  # GET /fem_feeds/1/edit
  def edit
    @fem_feed = FemFeed.find(params[:id])
  end

  # POST /fem_feeds
  def create
    @fem_feed = FemFeed.new(fem_feed_params)

    if @fem_feed.save
      redirect_to @fem_feed, notice: 'Fem feed was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /fem_feeds/1
  def update
    @fem_feed = FemFeed.find(params[:id])
    @fem_feed.updated = true

    respond_to do |format|
      if @fem_feed.update_attributes(fem_feed_params)
        format.html { redirect_to project_fem_feeds_path(@project, :field_id => params[:fem_feed][:field_id], :caller_id => "FEM"), notice: 'General Input was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @fem_feed.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fem_feeds/1
  def destroy
    @fem_feed.destroy
    redirect_to fem_feeds_url, notice: 'Fem feed was successfully destroyed.'
  end

  def reset
    @field = Field.find(params[:id])
    FemFeed.where(:project_id => @project.id).delete_all
    redirect_to project_fem_feeds_path(@project, :field_id => @field.id, :button => t('fem.feed')), notice: t("models.apex_control") + " " + t("general.reset")
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fem_feed
      @fem_feed = FemFeed.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def fem_feed_params
      params.require(:fem_feed).permit(:name, :unit, :selling_price, :purchase_price, :concentrate, :forage, :grain, :hay, :pasture, :silage, :supplement, :updated)
    end
end
