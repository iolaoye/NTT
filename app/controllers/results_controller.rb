class ResultsController < ApplicationController
  include OperationsHelper
  ###############################  MONTHLY CHART  ###################################
  def monthly_charts
    @type = t('general.view') + ' ' + t('result.monthly') + "-" + t('result.charts')
    index
    #render "index"
  end
  ###############################  ANNUAL CHART  ###################################
  def annual_charts
    @type = t('general.view') + ' ' + t('result.annual') + "-" + t('result.charts')
    index
    #render "index"
  end
  ###############################  BY SOIL  ###################################
  def by_soils
    @type = t("result.summary") + " " + t("result.by_soil")
    index
    #render "index"
  end

  ###############################  SUMMARY ###################################
  def summary
    @project = Project.find(params[:project_id])
    @type = t("general.view")
    index
    #render "index"
  end

  def fem_results
    @type = t('activerecord.models.result.fem_results')
    index
  end

  def aplcat_results
    @type = t('activerecord.models.result.aplcat_results')
    index
  end
  ###############################  INDEX  ###################################
  # GET /results
  # GET /results.json
  def index
    require 'enumerable/confidence_interval'
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
    @group = 0
    @title = ""
    @total_area1 = 0
    @total_area2 = 0
    @total_area3 = 0
    total_area = 0
    @field_name = ""
    @descriptions = Description.select("id, description, spanish_description").where("id < 71 or (id > 80 and id < 200)")
    add_breadcrumb t('menu.results')
    @scenario1 = "0"
    @scenario2 = "0"
    @scenario3 = "0"
    @averages1 = []
    @averages2 = []
    @averages3 = []
    simul = ""

    if session[:simulation].eql?('scenario') then
        simul = "scenario_id"
        @field_name = @field.field_name
        if params[:result1] != nil then
            if params[:result1][:scenario_id] == nil then
                @scenario1 = session[:scenario1] unless session[:scenario1] == nil or session[:scenario1] == "" or @field.scenarios.find_by_id(session[:scenario1]) == nil
            else
                @scenario1 = params[:result1][:scenario_id]
            end
        else
            @scenario1 = session[:scenario1] unless session[:scenario1] == nil or session[:scenario1] == "" or @field.scenarios.find_by_id(session[:scenario1]) == nil
        end
        if params[:result2] != nil then
            if params[:result2][:scenario_id] == nil then
                @scenario2 = session[:scenario2] unless session[:scenario2] == nil or session[:scenario2] == "" or @field.scenarios.find_by_id(session[:scenario2]) == nil
            else
                @scenario2 = params[:result2][:scenario_id]
            end
        else
            @scenario2 = session[:scenario2] unless session[:scenario2] == nil or session[:scenario2] == "" or @field.scenarios.find_by_id(session[:scenario2]) == nil
        end
        if params[:result3] != nil then
            if params[:result3][:scenario_id] == nil then
                @scenario3 = session[:scenario3] unless session[:scenario3] == nil or session[:scenario3] == "" or @field.scenarios.find_by_id(session[:scenario3]) == nil
            else
                @scenario3 = params[:result3][:scenario_id]
            end
        else
            @scenario3 = session[:scenario3] unless session[:scenario3] == nil or session[:scenario3] == "" or @field.scenarios.find_by_id(session[:scenario3]) == nil
        end
    else
        simul = "watershed_id"
        if params[:result1] != nil then
            if params[:result1][:scenario_id] == nil then
                @scenario1 = session[:scenario1] unless session[:scenario1] == nil or session[:scenario1] == "" or @project.location.watersheds.find_by_id(session[:scenario1]) == nil
            else
                @scenario1 = params[:result1][:scenario_id]
            end
        else
            @scenario1 = session[:scenario1] unless session[:scenario1] == nil or session[:scenario1] == "" or @project.location.watersheds.find_by_id(session[:scenario1]) == nil
        end
        if params[:result2] != nil then
            if params[:result2][:scenario_id] == nil then
                @scenario2 = session[:scenario2] unless session[:scenario2] == nil or session[:scenario2] == "" or @project.location.watersheds.find_by_id(session[:scenario2]) == nil
            else
                @scenario2 = params[:result2][:scenario_id]
            end
        else
            @scenario2 = session[:scenario2] unless session[:scenario2] == nil or session[:scenario2] == "" or @project.location.watersheds.find_by_id(session[:scenario2]) == nil
        end
        if params[:result3] != nil then
            if params[:result3][:scenario_id] == nil then
                @scenario3 = session[:scenario3] unless session[:scenario3] == nil or session[:scenario3] == "" or @project.location.watersheds.find_by_id(session[:scenario3]) == nil
            else
                @scenario3 = params[:result3][:scenario_id]
            end
        else
            @scenario3 = session[:scenario3] unless session[:scenario3] == nil or session[:scenario3] == "" or @project.location.watersheds.find_by_id(session[:scenario3]) == nil
        end
    end
    @soil = "0"
    #load crop for each scenario selected
    i = 70
    #if params[:result1] != nil then
    if @scenario1 > "0" then
      @present = true
      @before_button_clicked = false
      @errors = Array.new
    end # end if

    if params[:button] != nil
        #@type = params[:button]
        # dry years menu item was clicked
        if (params[:button] == t('result.dry_years'))
            @type = t("result.dry_years")
        # wet years menu item was clicked
        elsif params[:button] == t('result.wet_years')
            @type = t("result.wet_years")
        # default to tabular / all years
        else
          if !(@type == t('activerecord.models.result.fem_results')) then
            @type = t("result.summary")
          end
        end
    else
        if params[:button_annual] != nil
            @type = t("general.view") + " " + t('result.annual') + "-" + t('result.charts')
            @title = t('result.upto12')
        end
        if params[:button_monthly] != nil
            @type = t("general.view") + " " + t('result.monthly') + "-" + t('result.charts')
        end
    end

    if params[:year_type] != nil
        case params[:year_type][:year_type]
            when t('result.dry_years')
                @type = t('result.dry_years')
            when t('result.wet_years')
                @type = t('result.wet_years')
            when t('result.summary')
                @type = t('result.summary')
        end
    end

    if @type == nil then
        @type = t("general.view")
    end
    if @type != nil
      @cis1 = nil
      (@type.eql?(t("general.view") + " " + t("result.by_soil")) && params[:result4]!=nil) ? @soil = params[:result4][:soil_id] : @soil = "0"
      case @type
        when t("general.view"),
            t("result.summary"),
            t('result.all_years'),
            t('result.dry_years'),
            t('result.wet_years'),
            t("general.view") + " " + t("result.by_soil"),
            t("result.summary") + " " + t("result.by_soil")

            get_results = lambda do |scenario_id|
                if not (scenario_id.eql? "0" or scenario_id.eql? "")

                    results_data = AnnualResult.select('*','no3-qn as no3','flow-surface_flow as flow').where(:sub1 => 0, simul.to_sym => scenario_id)
                    results_data.each do |rs|
                      if rs.co2 == nil
                        rs.co2 = 0
                        rs.save
                      end
                    end
                    order = 'ASC'
                    if @type.eql? t('result.dry_years') then
                        count = results_data.size * 0.25
                    elsif @type.eql? t('result.wet_years') then
                        order = 'DESC'
                        count = results_data.size * 0.25
                    else
                        count = results_data.size
                    end

                    if session[:simulation] == 'scenario'
                        total_area = @field.field_area
                        bmps = Scenario.find(scenario_id).bmps
                        bmps.each do |b|
                            case b.bmpsublist_id
                                when 13, 8
                                    if b.sides == 1 then
                                        total_area -= b.area
                                    end
                                when 14, 15
                                    total_area -= b.area
                            end
                        end
                    else
                      if !params[:result1] == nil
                        if !params[:result1][:scenario_id].empty? then
                            watershed_scenarios = WatershedScenario.where(
                              :watershed_id => Watershed.find(params[:result1][:scenario_id]).id)
                            watershed_scenarios.each do |ws|
                                total_area += Field.find(ws.field_id).field_area
                            end
                        end
                      end
                    end

                    # determine which scenario this is.
                    cis = results_data.order('pcp '+order)
                                      .limit(count)
                                      .group_by(&:sub1).map { |k, v|
                        [k, v.map(&:orgn).confidence_interval,
                                 v.map(&:qn).confidence_interval,
                                 v.map(&:no3).confidence_interval,
                                 v.map(&:qdrn).confidence_interval,
                                 v.map(&:orgp).confidence_interval,
                                 v.map(&:po4).confidence_interval,
                                 v.map(&:qdrp).confidence_interval,
                                 v.map(&:surface_flow).confidence_interval,
                                 v.map(&:flow).confidence_interval,
                                 v.map(&:qdr).confidence_interval,
                                 v.map(&:irri).confidence_interval,
                                 v.map(&:dprk).confidence_interval,
                                 v.map(&:sed).confidence_interval,
                                 v.map(&:ymnu).confidence_interval,
                                 v.map(&:co2).confidence_interval,
                                 v.map(&:n2o).confidence_interval
                        ]}

                    values = []
                    averages = []
                    fields = ['orgn', 'qn', 'no3-qn', 'qdrn', 'orgp', 'po4', 'qdrp', 'surface_flow',
                      'flow-surface_flow','qdr', 'irri', 'dprk','sed','ymnu','co2','n2o']
                    fields.each do |f|
                      values.push(results_data.order('pcp ' + order).limit(count).pluck(f).inject(:+) / count)
                    end

                    averages.push(values)

                    totals = AnnualResult.where(:sub1 => 0, simul.to_sym => scenario_id)
                                         .order('pcp ' + order)
                                         .limit(count)
                                         .pluck('avg(orgn)*' + total_area.to_s,
                                                'avg(qn)*'  + total_area.to_s,
                                                'avg(no3-qn)*' + total_area.to_s,
                                                'avg(qdrn)*' + total_area.to_s,
                                                'avg(orgp)*' + total_area.to_s,
                                                'avg(po4)*' + total_area.to_s,
                                                'avg(qdrp)*' + total_area.to_s,
                                                'avg(surface_flow)*' + total_area.to_s,
                                                'avg(flow-surface_flow)*' + total_area.to_s,
                                                'avg(qdr)*' + total_area.to_s,
                                                'avg(irri)*' + total_area.to_s,
                                                'avg(dprk)*' + total_area.to_s,
                                                'avg(sed)*' + total_area.to_s,
                                                'avg(ymnu)*' + total_area.to_s,
                                                'avg(co2)*' + total_area.to_s,
                                                'avg(n2o)*' + total_area.to_s)
                    crops_data = CropResult.select('*', 'yldg+yldf AS yield')
                                      .where(simul + " = ? AND yldg+yldf > ?", scenario_id, 0)

                    years = results_data.order('pcp '+order).limit(count).map(&:year)
                    crops_data = crops_data.where(:year => years)
                    cic = Hash[*crops_data.group_by(&:name).map { |k,v| [k, v.map(&:yield).confidence_interval] }.flatten]

                    crops = crops_data.where(simul + " = ? AND (yldg + yldf) > ?", scenario_id, 0)
                                        .order("name")
                                        .group(:name)
                                        .pluck('avg(yldg+yldf)', 'avg(ws)', 'avg(ns)', 'avg(ps)', 'avg(ts)', 'name','avg(yldg)')

                    return cis, averages, totals, cic, crops, total_area
                else
                    return [],[],[],[],[],[],0
                end
            end

            @cis1, @averages1, @totals1, @cic1, @crops1, @total_area1 = get_results.call @scenario1
            @cis2, @averages2, @totals2, @cic2, @crops2, @total_area2 = get_results.call @scenario2
            @cis3, @averages3, @totals3, @cic3, @crops3, @total_area3 = get_results.call @scenario3
        when t('activerecord.models.result.fem_results')
          if @scenario1 != "0" && @scenario1 != "" then @fem_results1 = Scenario.find(@scenario1).fem_result end
          if @scenario2 != "0" && @scenario2 != "" then @fem_results2 = Scenario.find(@scenario2).fem_result end
          if @scenario3 != "0" && @scenario3 != "" then @fem_results3 = Scenario.find(@scenario3).fem_result end

          when t('activerecord.models.result.aplcat_results')
            if @scenario1 != "0" && @scenario1 != "" then @aplcat_results1 = Scenario.find(@scenario1).aplcat_results end
            if @scenario2 != "0" && @scenario2 != "" then @aplcat_results2 = Scenario.find(@scenario2).aplcat_results end
            if @scenario3 != "0" && @scenario3 != "" then @aplcat_results3 = Scenario.find(@scenario3).aplcat_results end

        when t('result.download_pdf')
          #@result_selected = t('result.summary')

        when t("general.view") + " " + t('result.annual') + "-" + t('result.charts')
              @chart_type = 0
          @x = "Year"
          @crops = Array.new
              if params[:result5] != nil && params[:result5][:description_id] != "" then
                @description = params[:result5][:description_id]
                @group = params[:result5_category][:group_id]
                    if params[:result5][:description_id] == "70" then
                        crop = Crop.find(params[:result7][:crop_id])
                        @title = crop.name
                        @chart_type = params[:result7][:crop_id].to_i
                        @y = crop.yield_unit
                        @crop = crop.id
                    else
                        @title = Description.find(@description).description
                        @chart_type = 0
                        @y = Description.find(@description).unit
                    end
                if params[:result1] != nil
                  if params[:result1][:scenario_id] != "" then
                    @scenario1 = params[:result1][:scenario_id]
                    @charts1 = get_chart_serie(@scenario1, 1)
                    if @charts1.count > 0
                      @present1 = true
                    else
                      #@errors.push(t('result.first_scenario_error') + " " + t('general.values').pluralize.downcase)
                    end
                  end
                  if params[:result2][:scenario_id] != "" then
                    @scenario2 = params[:result2][:scenario_id]
                    @charts2 = get_chart_serie(@scenario2, 1)
                    if @charts2.count > 0
                      @present2 = true
                    else
                      #@errors.push(t('result.second_scenario_error') + " " + t('general.values').pluralize.downcase)
                    end
                  end
                  if params[:result3][:scenario_id] != "" then
                    @scenario3 = params[:result3][:scenario_id]
                    @charts3 = get_chart_serie(@scenario3, 1)
                    if @charts3.count > 0
                      @present3 = true
                    else
                      #@errors.push(t('result.third_scenario_error') + " " + t('general.values').pluralize.downcase)
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
            description = Description.find(@description)
            @title = description.description
            @y = description.unit
            if params[:result1] != nil
              if params[:result1][:scenario_id] != "" then
                @scenario1 = params[:result1][:scenario_id]
                @charts1 = get_chart_serie(@scenario1, 2)
                if @charts1.count > 0
                  @present1 = true
                else
                  #@errors.push(t('result.first_scenario_error') + " " + t('result.charts').pluralize.downcase)
                end
              end
              if params[:result2][:scenario_id] != "" then
                @scenario2 = params[:result2][:scenario_id]
                @charts2 = get_chart_serie(@scenario2, 2)
                if @charts2.count > 0
                  @present2 = true
                else
                  #@errors.push(t('result.second_scenario_error') + " " + t('result.charts').pluralize.downcase)
                end
              end
              if params[:result3][:scenario_id] != "" then
                @scenario3 = params[:result3][:scenario_id]
                @charts3 = get_chart_serie(@scenario3, 2)
                if @charts3.count > 0
                  @present3 = true
                else
                  #@errors.push(t('result.third_scenario_error') + " " + t('result.charts').pluralize.downcase)
                end
              end
            end
          else
            @description = ""
            @title = ""
            @y = ""
          end


        end #end if params button summary
      end # end case type
      session[:scenario1] = @scenario1
      session[:scenario2] = @scenario2
      session[:scenario3] = @scenario3

    if params[:format] == "pdf" then
      pdf = render_to_string pdf: "report",
      page_size: "Letter", layout: "pdf",
      template: "/results/report",
      footer: {center: '[page] of [topage]'},
      header: {spacing: -5, html: {template: '/layouts/_report_header.html'}},
      margin: {top: 40}
      send_data(pdf, :filename => "report.pdf")
      return
    end
     # if format is pdf
    if params[:action] == "index" || params[:action] == "fem_results" then   # just run the format for Tabular => General menu option.
      respond_to do |format|
        format.html
        format.xlsx { response.headers['Content-Disposition'] = "attachment; filename=\"report-#{Date.today}.xlsx\"" }
        format.csv { send_data @crop_results.to_csv, filename: "report-#{Date.today}.csv"}
      end
    end
  end  # end Method Index

  ###############################  SHOW  ###################################
  # GET /results/1
  # GET /results/1.json
  def show
    case true
    when params[:id2] == "" && params[:id3] == ""
        @crops = Result.select("crop_id, crops.name, crops.spanish_name").joins(:crop).where("description_id < ? and (scenario_id = ?)", 100, params[:id]).uniq
    when params[:id2] != "" && params[:id3] == ""
        @crops = Result.select("crop_id, crops.name, crops.spanish_name").joins(:crop).where("description_id < ? and (scenario_id = ? or scenario_id = ?)", 100, params[:id], params[:id2]).uniq
    when params[:id2] != "" && params[:id3] != ""
        @crops = Result.select("crop_id, crops.name, crops.spanish_name").joins(:crop).where("description_id < ? and (scenario_id = ? or scenario_id = ? or scenario_id = ?)", 100, params[:id], params[:id2], params[:id3]).uniq
    when params[:id2] == "" && params[:id3] != ""
        @crops = Result.select("crop_id, crops.name, crops.spanish_name").joins(:crop).where("description_id < ? and (scenario_id = ? or scenario_id = ?)", 100, params[:id], params[:id3]).uniq
    end

    #@crops = Result.select("crop_id, crops.name, crops.spanish_name").joins(:crop).where("description_id < ? and (scenario_id == ? or scenario_id == ? or scenario_id == ?)", 100, params[:id], params[:id2], params[:id3]).uniq
    respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @crops }
    end
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
    @result = Result.where(:field_id => params[:id], :scenario_id => [params[:scenario1], params[:scenario2], params[:scenario3]], :soil_id => 0).where("crop_id > 0")

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
    #
    if month_or_year == 1 then #means chart is annual
        if session[:simulation] != 'scenario' then
            watershed_scenarios = WatershedScenario.where(:watershed_id => scenario_id)
            watershed_scenarios.each do |ws|
                params[:field_id] = ws.field_id
            end
        end
        first_year = params[:sim_initial_year].to_i
        if first_year == 0 then
            first_year = Field.find(params[:field_id]).weather.simulation_initial_year + 1
        end
        debugger
        if @chart_type > 0 then
            chart_values = Chart.select("month_year, value")
                                .where("field_id = ? AND scenario_id = ? AND soil_id = ? AND crop_id = ? AND month_year > ? AND description_id < ?",
                                        params[:field_id], scenario_id, @soil, @chart_type, first_year, 80).order("month_year desc").reverse
        else
            if session[:simulation] != 'scenario'
                chart_values = Chart.select("month_year, value")
                                    .where("field_id = ? AND watershed_id = ? AND soil_id = ? AND description_id = ? AND month_year > ?", 0,
                                            scenario_id, @soil, @description, first_year).order("month_year desc").reverse
            else
                chart_values = Chart.select("month_year, value")
                                    .where("field_id = ? AND scenario_id = ? AND soil_id = ? AND description_id = ? AND month_year > ?",
                                            params[:field_id], scenario_id, @soil, @description, first_year).order("month_year desc").reverse
            end
        end
    else #means chart is monthly average
      if session[:simulation] != 'scenario'
        chart_values = Chart.select("month_year, value").where("field_id = ? AND watershed_id = ? AND soil_id = ? AND description_id = ? AND month_year <= ?", 0, scenario_id, @soil, @description, 12)
      else
        chart_values = Chart.select("month_year, value").where("field_id = ? AND scenario_id = ? AND soil_id = ? AND description_id = ? AND month_year <= ?", params[:field_id], scenario_id, @soil, @description, 12)
      end
    end
    if chart_values == nil || chart_values.blank? then   # means the scenario hasn't been simulated or it was using the new result file annual_results
        id = "scenario_id"
        if session[:simulation] != "scenario" then
            id = "watershed_id"
        end
        if month_or_year == 1 then   # get results for annual values sub1 == 0
            chart_description = get_description_annual()
            if @description != "70" then
                chart_values = AnnualResult.select("year AS month_year", chart_description).where(:sub1 => 0, :"#{id}" => scenario_id)
            else
                crop = Crop.find(params[:result7][:crop_id])
                conversion_factor = crop.conversion_factor * AC_TO_HA / (crop.dry_matter/100)
                chart_values = CropResult.select("year as month_year", "(yldg+yldf) * " + conversion_factor.to_s + " as value").where(:"#{id}" => scenario_id, :name => crop.code).group(:month_year)
                #chart_values = CropResult.select("year AS month_year", "yldg+yldf as value").where(:scenario_id => 736).group(:name, :year).pluck("yldg+yldf as value").last(12)
            end
        else  #get results for monthly sub1 > 0
            chart_description = get_description_monthly()
            chart_values = AnnualResult.select("year AS month_year").where("sub1 > ? AND " + id + " = ?", 0, scenario_id).group(:sub1).pluck(chart_description)
        end
    end
    charts = Array.new(chart_values.length)
    if month_or_year == 2 then  #monthly
        for i in 1..chart_values.length
        #chart_values.each do |c|
          chart = Array.new
          #chart.push(c.month_year)
          #chart.push(listMonths[c.month_year-1][0])
          chart.push(t('date.abbr_month_names')[i])
          chart.push(chart_values[i-1])
          charts[i-1] = chart
        end
    else  # annual
        current_year = first_year + 1
        i = 0
        if chart_values.length == 0 then
            for i in 0..11
                chart = Array.new
                chart.push(current_year)
                chart.push(0)
                current_year += 1
                charts[i] = chart
            end
        else
            last_year = params[:sim_final_year].to_i
            if last_year == 0 then
                last_year = Field.find(params[:field_id]).weather.simulation_final_year
            end
            chart_values.each do |c|
                #
                # while current_year < c.month_year
                #     chart = Array.new
                #     chart.push(current_year)
                #     chart.push(0)
                #     charts[i] = chart
                #     current_year +=1
                #     i += 1
                # end
                if c.month_year >= first_year and c.month_year <= last_year then
                    chart = Array.new
                    chart.push(c.month_year)
                    chart.push(c.value)
                    charts[i] = chart
                    current_year +=1
                    i += 1
                    if i > last_year then break end
                    #if i > 11 then break end
                end
            end
        end
    end
    return charts.compact
  end #end method get_chart_serie

    def get_description_monthly
        case @description
        when "21"
            chart_description = "avg(orgn)"
        when "22"
            chart_description = "avg(no3)"
        when "31"
            chart_description = 'avg(orgp)'
        when "32"
            chart_description = 'avg(po4)'
        when "41"
            chart_description = 'avg(surface_flow)'
        when "61"
            chart_description = 'avg(sed)'
        else
            chart_description = ""
        end
    end

    def get_description_annual
        case @description
        when "20"
            chart_description = "orgn + no3 + qdrn AS value"
        when "21"
            chart_description = "orgn AS value"
        when "22"
            chart_description = "qn AS value"
        when "23"
            chart_description = "no3 - qn AS value"
        when "24"
            chart_description = "qdrn AS value"
        when "30"
            chart_description = "orgp + po4 + qdrp AS value"
        when "31"
            chart_description = "orgp AS value"
        when "32"
            chart_description = "po4 AS value"
        when "33"
            chart_description = "qdrp AS value"
        when "40"
            chart_description = "flow + qdr AS value"
        when "41"
            chart_description = "surface_flow AS value"
        when "42"
            chart_description = "flow - surface_flow AS value"
        when "43"
            chart_description = "qdr AS value"
        when "50"
            chart_description = "irri + dprk AS value"
        when "51"
            chart_description = "irri AS value"
        when "52"
            chart_description = "dprk AS value"
        when "60"
            chart_description = "sed + ymnu AS value"
        when "61"
            chart_description = "sed AS value"
        when "62"
            chart_description = "ymnu AS value"
        when "70"
            chart_description = "yldg+yldf AS value"
        when "92"
            chart_description = "n2o AS value"
        when "100"
            chart_description = "pcp AS value"
        else
            chart_description = ""
        end
    end
end
