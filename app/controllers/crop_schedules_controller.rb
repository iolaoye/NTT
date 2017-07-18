class CropSchedulesController < ApplicationController
  # GET /crop_schedules
  # GET /crop_schedules.json
  def index
    @crop_schedules = CropSchedule.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @crop_schedules }
    end
  end

  # GET /crop_schedules/1
  # GET /crop_schedules/1.json
  def show
    @crop_schedule = CropSchedule.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @crop_schedule }
    end
  end

  # GET /crop_schedules/new
  # GET /crop_schedules/new.json
  def new
    @crop_schedule = CropSchedule.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @crop_schedule }
    end
  end

  # GET /crop_schedules/1/edit
  def edit
    @crop_schedule = CropSchedule.find(params[:id])
  end

  # POST /crop_schedules
  # POST /crop_schedules.json
  def create
    @crop_schedule = CropSchedule.new(crop_schedule_params)

    respond_to do |format|
      if @crop_schedule.save
        format.html { redirect_to @crop_schedule, notice: 'Crop schedule was successfully created.' }
        format.json { render json: @crop_schedule, status: :created, location: @crop_schedule }
      else
        format.html { render action: "new" }
        format.json { render json: @crop_schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /crop_schedules/1
  # PATCH/PUT /crop_schedules/1.json
  def update
    @crop_schedule = CropSchedule.find(params[:id])

    respond_to do |format|
      if @crop_schedule.update_attributes(crop_schedule_params)
        format.html { redirect_to @crop_schedule, notice: 'Crop schedule was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @crop_schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /crop_schedules/1
  # DELETE /crop_schedules/1.json
  def destroy
    @crop_schedule = CropSchedule.find(params[:id])
    @crop_schedule.destroy

    respond_to do |format|
      format.html { redirect_to crop_schedules_url }
      format.json { head :no_content }
    end
  end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def crop_schedule_params
      params.require(:crop_schedule).permit(:class, :self_id, :name, :state_id, :status)
    end
end
