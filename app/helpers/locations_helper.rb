module LocationsHelper
  def load_parameters(parm_number)
    apex_parameters = ApexParameter.where(:project_id => params[:project_id])
	if apex_parameters == [] || parm_number > 0 then
      parameters = Parameter.where("state_id = " + Location.find(session[:location_id]).state_id.to_s + " AND number > " + parm_number.to_s)
      if parameters.blank? || parameters == nil then
		parameters = Parameter.where(:state_id => 99)
        parameters = Parameter.where("state_id = 99 AND number > " + parm_number.to_s)
	  end
      parameters.each do |c|
		apex_parameter = ApexParameter.new
		apex_parameter.parameter_description_id = c.id
		apex_parameter.value = c.default_value
		apex_parameter.project_id = params[:project_id]
		apex_parameter.save
      end # end Parameter.all
	end # end if apex_controls == []
  end # end def
end
