class ResultsController < ApplicationController
  # GET /results
  # GET /results.json
  def index
		if params[:language] != nil then
			if params[:language][:language].eql?("es") 
				I18n.locale = :es 
			else
				I18n.locale = :en			
			end
		end 
		@total_area = Field.find(session[:field_id]).field_area
		@project_name = Project.find(session[:project_id]).name
		@field_name = Field.find(session[:field_id]).field_name
		@scenario1 = 0
		@scenario2 = 0
		@scenario3 = 0
		@descrition = 0
		@soil = "0"
		@result_selected = params[:button]
		@title = ""
		@descriptions = Description.select("id, description, spanish_description").where("id < 70 OR id > 79")
		#load crop for each scenario selected
		i = 70
		if params[:result1] != nil then
			results = Result.new
			case true
				when params[:result1][:scenario_id] != "" && params[:result2][:scenario_id] != "" && params[:result3][:scenario_id] != ""
					results = Result.where(:field_id == params[:field][:id], :scenario_id => params[:result1][:scenario1], :scenario_id => params[:result2][:scenario2], :scenario_id => params[:result3][:scenario3], :soil_id => 0).where("crop_id > 0")
				when params[:result1][:scenario_id] != "" && params[:result2][:scenario_id] != "" 
					results = Result.where(:field_id == params[:field][:id], :scenario_id => params[:result1][:scenario1], :scenario_id => params[:result2][:scenario2]).where("crop_id > 0")
				when params[:result1][:scenario_id] != "" 
					results = Result.where(:field_id == params[:field][:id], :scenario_id => params[:result1][:scenario1]).where("crop_id > 0")
			end # end case true
			results.each do |result|
				i+=1
				#get crops name for each result to add to description list 
				crop = Crop.find(result.crop_id)
			end # end results.each
		end # end if
		@type = params[:button]
		if params[:button] != nil then
			params[:button].eql?(t("result.summary") + " " + t("result.by_soil") && params[:result4]!=nil)? @soil = params[:result4][:soil_id] : @soil = "0" 
			case @type
				when t("result.summary"), t("result.summary") + " " + t("result.by_soil")
					if params[:button].include? t('result.summary') then 
						
						#@result_selected = t('result.summary')
						if params[:result1] != nil
							session[:first_if] = true
							session[:result1] = !params[:result1][:scenario_id].eql?("")
							if !params[:result1][:scenario_id].eql?("") then
								@scenario1 = params[:result1][:scenario_id] 			
								@results1 = Result.where(:field_id => session[:field_id], :scenario_id => @scenario1, :soil_id => @soil)
								session[:scenario1] = @scenario1
								session[:scenario2] = ""
								session[:scenario3] = ""
								#session[:results] = @results1
							end
							session[:result2] = params[:result2][:scenario_id] != ""
							if params[:result2][:scenario_id] != "" then
								@scenario2 = params[:result2][:scenario_id]
								@results2 = Result.where(:field_id => session[:field_id], :scenario_id => @scenario2, :soil_id => @soil)
								session[:scenario2] = @scenario2
								session[:scenario3] = ""
							end
							session[:result3] = params[:result3][:scenario_id] != ""
							if params[:result3][:scenario_id] != "" then
								@scenario3 = params[:result3][:scenario_id]
								@results3 = Result.where(:field_id => session[:field_id], :scenario_id => @scenario3, :soil_id => @soil)
								session[:scenario3] = @scenario3
							end
						end # end if params[:result1] != nill
					end  #end if params button summary
					
				when t('result.download_pdf')
						#@result_selected = t('result.summary')
						
				when t('result.annual')  + "-" + t('result.charts') 
					@x = "Year"
					if params[:result5] != nil && params[:result5][:description_id] != "" then
						@description = params[:result5][:description_id] 
						@title = Description.find(@description).description
						@y = Description.find(@description).unit
						if params[:result1] != nil
							if params[:result1][:scenario_id] != "" then
								@scenario1 = params[:result1][:scenario_id] 	
								@charts1 = get_chart_serie(@scenario1, 1)
							end
							if params[:result2][:scenario_id] != "" then
								@scenario2 = params[:result2][:scenario_id]
								@charts2 = get_chart_serie(@scenario2, 1)
							end
							if params[:result3][:scenario_id] != "" then
								@scenario3 = params[:result3][:scenario_id]
								@charts3 = get_chart_serie(@scenario3, 1)
							end
						end
					else
						@description = ""
						@title = ""
						@y = ""
					end
				when t('result.monthly')  + "-" + t('result.charts') 
					@x = "Month"
					if params[:result6] != nil && params[:result6][:description_id] != ""  then 
						@description = params[:result6][:description_id]
						@title = Description.find(@description).description
						@y = Description.find(@description).unit
						if params[:result1] != nil
							if params[:result1][:scenario_id] != "" then
								@scenario1 = params[:result1][:scenario_id] 	
								@charts1 = get_chart_serie(@scenario1, 2)
							end
							if params[:result2][:scenario_id] != "" then
								@scenario2 = params[:result2][:scenario_id]
								@charts2 = get_chart_serie(@scenario2, 2)
							end
							if params[:result3][:scenario_id] != "" then
								@scenario3 = params[:result3][:scenario_id]
								@charts3 = get_chart_serie(@scenario3, 2)
							end
						end
					else
						@description = ""
						@title = ""
						@y = ""
					end
			end	# end case type
		end # end if != nill <!--<h1><%=@result_selected + " " + @title%></h1>-->
		
		if params[:format] == "pdf" then
				pdf = render_to_string pdf: "report",
						page_size: "Letter", layout: "pdf",
						template: "/results/report", 
						footer: { center: '[page] of [topage]' },
						header: { spacing: -6, html: { template: '/layouts/_report_header.html' } },
						margin: { top: 16 }
				send_data(pdf, :filename => "report.pdf")
			#end  # end format pdf
			#format.html { render action: "index" }
			#format.json { render json: "index"}
			#end # end respond to do
		end # if format is pdf
  end

  #def download
	#respond_to do |format|
		#format.pdf do
			#render pdf: "tester", 
            #layout: "pdf",
            #template: "/results/tester" 
		#end
  #end 
# results?result1%5Bscenario_id%5D=4&result2%5Bscenario_id%5D=5&result3%5Bscenario_id%5D=&language%5Blanguage%5D=en&field%5Bid%5D=3
# results?result1%5Bscenario_id%5D=4&result2%5Bscenario_id%5D=5&result3%5Bscenario_id%5D=&language%5Blanguage%5D=en&field%5Bid%5D=3
	# GET /results/1
  # GET /results/1.json
  def show
    @result = Result.find(params[:id])

    format.html # show.html.erb
    format.json { render json: @result }
    #end
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
		if month_or_year == 1 then   #means chart is annual
			chart_values = Chart.select("month_year, value").where("field_id == " + session[:field_id] + " AND scenario_id == " + scenario_id + " AND soil_id == " + @soil + " AND description_id == " + @description + " AND month_year > 12")
		else  #means chart is monthly average
			chart_values = Chart.select("month_year, value").where("field_id == " + session[:field_id] + " AND scenario_id == " + scenario_id + " AND soil_id == " + @soil + " AND description_id == " + @description + " AND month_year <= 12")
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
