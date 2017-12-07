class ImportancesController < ApplicationController
  before_action :set_importance, only: [:show, :edit, :update, :destroy]

  # GET /importances
  def index
    @importances = Importance.all
  end

  # GET /importances/1
  def show
  end

  # GET /importances/new
  def new
    @importance = Importance.new
  end

  # GET /importances/1/edit
  def edit
  end

  # POST /importances
  def create
    @importance = Importance.new(importance_params)

    if @importance.save
      redirect_to @importance, notice: 'Importance was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /importances/1
  def update
    if @importance.update(importance_params)
      redirect_to @importance, notice: 'Importance was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /importances/1
  def destroy
    @importance.destroy
    redirect_to importances_url, notice: 'Importance was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_importance
      @importance = Importance.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def importance_params
      params.require(:importance).permit(:name)
    end
end
