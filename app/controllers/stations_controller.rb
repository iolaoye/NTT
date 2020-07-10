class StationsController < ApplicationController
  # GET /stations
  # GET /stations.json
  def index
    @stations = Station.all
	  @location = Location.where(:project_id => params[:project_id]).first

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: [@stations, @location] }
    end
  end

  # GET /stations/1
  # GET /stations/1.json
  def show
    if params[:nlat] != nil then
      lat_less = params[:nlat].to_f - LAT_DIF
      lat_plus = params[:nlat].to_f + LAT_DIF
      lon_less = params[:nlon].to_f - LON_DIF
      lon_plus = params[:nlon].to_f + LON_DIF
      sql = "SELECT lat,lon,file_name,(lat-" + params[:nlat] + ") + (lon + " + params[:nlon] + ") as distance, final_year, initial_year"
      sql = sql + " FROM stations"
      sql = sql + " WHERE lat > " + lat_less.to_s + " and lat < " + lat_plus.to_s + " and lon > " + lon_less.to_s + " and lon < " + lon_plus.to_s  
      sql = sql + " ORDER BY distance"
      @station = Station.find_by_sql(sql).first
      if params[:state] != nil then
        file = "D:/Weather/1981-2017/PRISM From Rewati/Weather/" + params[:state] + "/" + @station.file_name
        client = Savon.client(wsdl: URL_SoilsInfoDev)
        ###### Get the WEATHER file to download ########
        response = client.call(:get_weather_info, message: {"file" => file, "i_year" => @station.initial_year, "f_year" => @station.final_year})
        if response.body[:get_weather_info_response][:get_weather_info_result].include? "Error" then
          return response.body[:get_weather_info_response][:get_weather_info_result]
        end
        rec = response.body[:get_weather_info_response][:get_weather_info_result][:string]
        file_name = session[:session_id] + ".wth"
        path = File.join(DOWNLOAD, file_name)
        File.open(path, "w+") do |f|
          rec.each do |row|
            f << row + "\n"
          end
        end
        #file.write(content)
        send_file path, :type => "application/xml", :x_sendfile => true
      else
        respond_to do |format|
          format.html # show.html.erb
          format.json { render json: @station }
        end
      end
    else
      @station = Station.find(params[:id])
    end
  end

  # GET /stations/new
  # GET /stations/new.json
  def new
    @station = Station.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @station }
    end
  end

  # GET /stations/1/edit
  def edit
    @station = Station.find(params[:id])
  end

  # POST /stations
  # POST /stations.json
  def create
    @station = Station.new(station_params)

    respond_to do |format|
      if @station.save
        format.html { redirect_to @station, notice: 'Station was successfully created.' }
        format.json { render json: @station, status: :created, location: @station }
      else
        format.html { render action: "new" }
        format.json { render json: @station.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stations/1
  # PATCH/PUT /stations/1.json
  def update
    @station = Station.find(params[:id])

    respond_to do |format|
      if @station.update_attributes(station_params)
        format.html { redirect_to @station, notice: 'Station was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @station.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stations/1
  # DELETE /stations/1.json
  def destroy
    @station = Station.find(params[:id])
    @station.destroy

    respond_to do |format|
      format.html { redirect_to stations_url }
      format.json { head :no_content }
    end
  end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def station_params
      params.require(:station).permit(:lat, :lon, :file_name, :initial_year, :final_year)
    end
end
