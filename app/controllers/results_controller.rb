class ResultsController < ApplicationController

  
  

  ###############################  MONTHLY CHART  ###################################
  def monthly_charts
  	@type = t('result.monthly') + "-" + t('result.charts')
  	index
  	render "index"
  end
  ###############################  ANNUAL CHART  ###################################
  def annual_charts
  	@type = t("general.view") + " " + t('result.annual') + "-" + t('result.charts')
  	index
  	render "index"
  end
  ###############################  BY SOIL  ###################################
  def by_soils
  	@type = t("result.summary") + " " + t("result.by_soil")
  	index
  	render "index"
  end
  ###############################  SUMMARY ###################################
  def summary
    @project = Project.find(params[:project_id])
  	@type = t("general.view")
  	index
  	render "index"
  end

  ###############################  INDEX  ###################################
  # GET /results
  # GET /results.json
  def index
  	if params[:simulation] != nil then
  		session[:simulation] = params[:simulation]
  	end
    if params[:language] != nil then
      if params[:language][:language].eql?("es")
        I18n.locale = :es
      else
        I18n.locale = :en
      end
    end
    @before_button_clicked = true
    @present1 = false
    @present2 = false
    @present3 = false
    @description = 0
    @title = ""
    @total_area = 0
    @field_name = ""
    @descriptions = Description.select("id, description, spanish_description").where("id < 70 OR id > 79")
    @project = Project.find(params[:project_id])
    
    add_breadcrumb 'Results'
    if session[:simulation].eql?('scenario') then
      @total_area = Field.find(params[:field_id]).field_area
      @field_name = Field.find(params[:field_id]).field_name
	else
	  @total_area = 0
	  if params[:result1] != nil then
		watershed_scenarios = WatershedScenario.where(:watershed_id => Watershed.find(params[:result1][:scenario_id]).id)
		watershed_scenarios.each do |ws|
			@total_area += Field.find(ws.field_id).field_area
		end
	  end
    end
  	if !(params[:field_id] == "0")
  		@field = Field.find(params[:field_id])
  	end
  	@scenario1 = session[:scenario1]
  	@scenario2 = session[:scenario2]
  	@scenario3 = session[:scenario3]
    @soil = "0"
    #load crop for each scenario selected
    i = 70
    if params[:result1] != nil then
      @present = true
      @before_button_clicked = false
      @errors = Array.new
      results = Result.new
      if session[:simulation] == 'scenario' then
        case true
          when params[:result1][:scenario_id] != "" && params[:result2][:scenario_id] != "" && params[:result3][:scenario_id] != ""
            results = Result.where(:field_id => params[:field_id], :scenario_id => params[:result1][:scenario_id], :scenario_id => params[:result2][:scenario_id], :scenario_id => params[:result3][:scenario_id], :soil_id => 0).where("crop_id > 0")
          when params[:result1][:scenario_id] != "" && params[:result2][:scenario_id] != ""
            results = Result.where(:field_id => params[:field_id], :scenario_id => params[:result1][:scenario_id], :scenario_id => params[:result2][:scenario_id]).where("crop_id > 0")
          when params[:result1][:scenario_id] != ""
            results = Result.where(:field_id => params[:field_id], :scenario_id => params[:result1][:scenario_id]).where("crop_id > 0")
        end # end case true
      else
        case true
          when params[:result1][:scenario_id] != "" && params[:result2][:scenario_id] != "" && params[:result3][:scenario_id] != ""
            results = Result.where(:watershed_id => params[:result1][:scenario_id], :watershed_id => params[:result2][:scenario_id], :watershed_id => params[:result3][:scenario_id]).where("crop_id > 0")
          when params[:result1][:scenario_id] != "" && params[:result2][:scenario_id] != ""
            results = Result.where(:watershed_id => params[:result1][:scenario_id], :watershed_id => params[:result2][:scenario_id]).where("crop_id > 0")
          when params[:result1][:scenario_id] != ""
            results = Result.where(:watershed_id => params[:result1][:scenario_id]).where("crop_id > 0")
        end # end case true
      end
      results.each do |result|
        i+=1
        #get crops name for each result to add to description list
        crop = Crop.find(result.crop_id)
      end # end results.each
    end # end if params[:result1] != nil
  	if params[:button] != nil
  		@type = params[:button]
  	end
  	if @type == nil then
  		@type = t("general.view")
  	end
    if @type != nil then
      (@type.eql?(t("general.view") + " " + t("result.by_soil")) && params[:result4]!=nil)? @soil = params[:result4][:soil_id] : @soil = "0"
      case @type
        when t("general.view"), t("result.summary") + " " + t("result.by_soil"), t("general.view") + " " + t("result.by_soil")
          if @type.include? t('general.view') then
            if params[:result1] != nil
              #session[:first_if] = true
              #session[:result1] = !params[:result1][:scenario_id].eql?("")
              if !params[:result1][:scenario_id].eql?("") then
                #session[:result1] = params[:result1][:scenario_id]
                @scenario1 = params[:result1][:scenario_id]
                session[:scenario1] = @scenario1
                if session[:simulation] == 'scenario'
                  @results1 = Result.where(:field_id => params[:field_id], :scenario_id => @scenario1, :soil_id => @soil)
                else
                  @results1 = Result.where(:watershed_id => @scenario1)
                end
                if @results1.count > 0
                  @present1 = true
                else
                  redirect_to project_field_results_path(@project, @field)
                  flash[:info] = t('result.first_scenario_error') + " " + t('result.result').pluralize.downcase and return false
                end
                session[:scenario2] = ""
                session[:scenario3] = ""
              end
              if params[:result2][:scenario_id] != "" then
                #session[:result2] = params[:result2][:scenario_id]
                @scenario2 = params[:result2][:scenario_id]
                session[:scenario2] = @scenario2
                if session[:simulation] == 'scenario'
                  @results2 = Result.where(:field_id => params[:field_id], :scenario_id => @scenario2, :soil_id => @soil)
                else
                  @results2 = Result.where(:watershed_id => @scenario2)
                end
                if @results2.count > 0
                  @present2 = true
                else
                  redirect_to project_field_results_path(@project, @field)
                  flash[:info] = t('result.second_scenario_error') + " " + t('result.result').pluralize.downcase and return false
                end
                session[:scenario3] = ""
              end
              if params[:result3][:scenario_id] != "" then
                #session[:result3] = params[:result3][:scenario_id]
                @scenario3 = params[:result3][:scenario_id]
                session[:scenario3] = @scenario3
                if session[:simulation] == 'scenario'
                  @results3 = Result.where(:field_id => params[:field_id], :scenario_id => @scenario3, :soil_id => @soil)
                else
                  @results3 = Result.where(:watershed_id => @scenario3)
                end
                if @results3.count > 0
                  @present3 = true
                else
                  redirect_to project_field_results_path(@project, @field)
                  flash[:info] = t('result.third_scenario_error') + " " + t('result.result').pluralize.downcase and return false
                end
              end
            end # end if params[:result1] != nill
          end #end if params button summary

        when t('result.download_pdf')
          #@result_selected = t('result.summary')

        when t("general.view") + " " + t('result.annual') + "-" + t('result.charts')
          @x = "Year"
          if params[:result5] != nil && params[:result5][:description_id] != "" then
            @description = params[:result5][:description_id]
            @title = Description.find(@description).description
            @y = Description.find(@description).unit
            if params[:result1] != nil
              if params[:result1][:scenario_id] != "" then
                @scenario1 = params[:result1][:scenario_id]
                @charts1 = get_chart_serie(@scenario1, 1)
                if @charts1.count > 0
                  @present1 = true
                else
                  @errors.push(t('result.first_scenario_error') + " " + t('result.charts').pluralize.downcase)
                end
              end
              if params[:result2][:scenario_id] != "" then
                @scenario2 = params[:result2][:scenario_id]
                @charts2 = get_chart_serie(@scenario2, 1)
                if @charts2.count > 0
                  @present2 = true
                else
                  @errors.push(t('result.second_scenario_error') + " " + t('result.charts').pluralize.downcase)
                end
              end
              if params[:result3][:scenario_id] != "" then
                @scenario3 = params[:result3][:scenario_id]
                @charts3 = get_chart_serie(@scenario3, 1)
                if @charts3.count > 0
                  @present3 = true
                else
                  @errors.push(t('result.third_scenario_error') + " " + t('result.charts').pluralize.downcase)
                end
              end
            end
          else
            @description = ""
            @title = ""
            @y = ""
          end
        when t("general.view") + " " + t('result.monthly') + "-" + t('result.charts')
          @x = "Month"
          if params[:result6] != nil && params[:result6][:description_id] != "" then
            @description = params[:result6][:description_id]
            @title = Description.find(@description).description
            @y = Description.find(@description).unit
            if params[:result1] != nil
              if params[:result1][:scenario_id] != "" then
                @scenario1 = params[:result1][:scenario_id]
                @charts1 = get_chart_serie(@scenario1, 2)
                if @charts1.count > 0
                  @present1 = true
                else
                  @errors.push(t('result.first_scenario_error') + " " + t('result.charts').pluralize.downcase)
                end
              end
              if params[:result2][:scenario_id] != "" then
                @scenario2 = params[:result2][:scenario_id]
                @charts2 = get_chart_serie(@scenario2, 2)
                if @charts2.count > 0
                  @present2 = true
                else
                  @errors.push(t('result.second_scenario_error') + " " + t('result.charts').pluralize.downcase)
                end
              end
              if params[:result3][:scenario_id] != "" then
                @scenario3 = params[:result3][:scenario_id]
                @charts3 = get_chart_serie(@scenario3, 2)
                if @charts3.count > 0
                  @present3 = true
                else
                  @errors.push(t('result.third_scenario_error') + " " + t('result.charts').pluralize.downcase)
                end
              end
            end
          else
            @description = ""
            @title = ""
            @y = ""
          end
      end # end case type
    end # end if != nill <!--<h1><%=@type + " " + @title%></h1>-->
    if params[:format] == "pdf" then
      pdf = render_to_string pdf: "report",
  	  page_size: "Letter", layout: "pdf",
  	  template: "/results/report",
  	  footer: {center: '[page] of [topage]'},
  	  header: {spacing: -6, html: {template: '/layouts/_report_header.html'}},
  	  margin: {top: 16}
      send_data(pdf, :filename => "report.pdf")
      #end  # end format pdf
      #format.html { render action: "index" }
      #format.json { render json: "index"}
      #end # end respond to do
    end # if format is pdf

    if params[:format] == "csv" then
      #results to excel catch with debugger for now (testing WIP)
      #respond_to do |format|
      #  format.html
      #  format.xls { send_data @products.to_csv(col_sep: "\t") }
      #end
    end # if format is excel

  end  # end Method Index

  ###############################  SHOW  ###################################
  # GET /results/1
  # GET /results/1.json
  def show
    @result = Result.find(params[:id])

    format.html # show.html.erb
    format.json { render json: @result }
    #end
  end

  ###############################  NEW  ###################################
  # GET /results/new
  # GET /results/new.json
  def new
    @result = Result.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @result }
    end
  end

  ###############################  EDIT  ###################################
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
        format.html { redirect_to @result, notice: t('result.result') + " " + t('general.success') }
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
    @result = Result.find(params[:id])

    respond_to do |format|
      if @result.update_attributes(result_params)
        format.html { redirect_to @result, notice: t('result.result') + " " + t('general.updated') }
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

  def sel
    @result = Result.where(:field_id => params[:id], :scenario_id => params[:scenario1], :scenario_id => params[:scenario2], :scenario_id => params[:scenario3], :soil_id => 0).where("crop_id > 0")

    respond_to do |format|
      format.html # sel.html.erb
      format.json { render json: @result }
    end
  end

  private

  # Use this method to whitelist the permissible parameters. Example:
  # params.require(:person).permit(:name, :age)
  # Also, you can specialize this method with per-user checking of permissible attributes.
  def result_params
    params.require(:result).permit(:field_id, :scenario_id, :soil_id, :value, :watershed_id, :description_id, :ci_value)
  end

  def get_chart_serie(scenario_id, month_or_year)
    if month_or_year == 1 then #means chart is annual
      chart_values = Chart.select("month_year, value").where("field_id == " + params[:field_id] + " AND scenario_id == " + scenario_id + " AND soil_id == " + @soil + " AND description_id == " + @description + " AND month_year > 12")
    else #means chart is monthly average
      chart_values = Chart.select("month_year, value").where("field_id == " + params[:field_id] + " AND scenario_id == " + scenario_id + " AND soil_id == " + @soil + " AND description_id == " + @description + " AND month_year <= 12")
    end
    charts = Array.new
    chart_values.each do |c|
      chart = Array.new
      chart.push(c.month_year)
      chart.push(c.value)
      charts.push(chart)
    end
    return charts
  end #end method get_chart_serie
end
