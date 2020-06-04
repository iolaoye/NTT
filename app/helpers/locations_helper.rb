module LocationsHelper
  def load_parameters(parm_number)
    #apex_parameters = ApexParameter.where(:project_id => params[:project_id])
    apex_parameters = ApexParameter.where(:project_id => @project.id)
	  if apex_parameters == [] || parm_number > 0 then
      parameters = Parameter.where("state_id = " + Location.find(@project.location.id).state_id.to_s + " AND number > " + parm_number.to_s)
      #parameters = Parameter.where("state_id = " + Location.find(session[:locataion.id]).state_id.to_s + " AND number > " + parm_number.to_s)
      if parameters.blank? || parameters == nil then
		    #parameters = Parameter.where(:state_id => 99)
        parameters = Parameter.where("state_id = 99 AND number > " + parm_number.to_s)
	    end
      parameters.each do |c|
		    apex_parameter = ApexParameter.new
		    apex_parameter.parameter_description_id = c.number
		    apex_parameter.value = c.default_value
		    apex_parameter.project_id = params[:project_id]
		    apex_parameter.save
      end # end Parameter.all
	  end # end if apex_controls == []
  end # end def

  def load_controls()
    apex_controls = ApexControl.where(:project_id => @project.id)
    if apex_controls == [] then
      controls = Control.where(:state_id => @project.location.state_id)
      if controls.blank? || controls == nil then
        controls = Control.where(:state_id => 99)   
      end
      controls.each do |c|
        apex_control = ApexControl.new
        apex_control.control_description_id = c.number
        case apex_control.control_description_id
          when 1
            if @weather.weather_final_year == nil or @weather.weather_initial_year == nil
              apex_control.value = c.default_value
            else
              apex_control.value = @weather.weather_final_year - @weather.weather_initial_year + 1
            end
          when 2
            if @weather.weather_initial_year == nil then
              apex_control.value = c.default_value
            else
              apex_control.value = @weather.weather_initial_year
            end
          else
            apex_control.value = c.default_value
        end
        
        apex_control.project_id = @project.id
        apex_control.save
      end # end control all
    end # end if
  end  #end method

end
