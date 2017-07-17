module ApplicationHelper

	def current_page(path)
	  "active" if request.url.include?(path)
	end

	#uniquely coded the welcome class because the auto redirect in welcomes controller prevents current_page from working on welcomes_path(0)
	def active_welcome?
		if controller.env["REQUEST_PATH"] == "/welcomes/0"
			"active"
		end
	end

	def field_submenu
		if current_page?(edit_project_field_weather_path(id: @field.weather.id))
			true
		elsif current_page?(url_for(controller: 'soils', :action => 'index'))
			true
		elsif current_page?(url_for(:controller => 'apex_controls', :action => 'index'))
			true
		elsif current_page?(url_for(:controller => 'apex_parameters', :action => 'index'))
			true
		elsif request.url.include?(url_for("/scenarios"))
			true
		elsif request.url.include?(url_for("/bmps"))
			true
		elsif request.url.include?(url_for("/results")) && session[:simulation] == 'scenario'
			true
		elsif request.url.include?(url_for("/layers"))
			true
		elsif request.url.include?(url_for("/subareas"))
			true
		elsif request.url.include?(url_for("/apex_soils"))
			true
		elsif request.url.include?(url_for("/soil_operations"))
			true
		elsif request.url.include?(url_for("/sites"))
			true
		elsif request.url.include?(url_for("/aplcat_parameters"))
			true
		elsif request.url.include?(url_for("/grazing_parameters"))
			true
		elsif request.url.include?(url_for("/supplement_parameters"))
			true
		else
			false
		end
	end

	def scenario_submenu
		if request.url.include?(url_for('/operations'))
			true
		elsif current_page?(url_for(:controller => 'operations', :action => 'index'))
			true
		elsif current_page?(url_for(:controller => 'operations', :action => 'new'))
			true
		elsif current_page?(url_for(:controller => 'bmps', :action => 'index'))
			true
		elsif params[:scenario_id] != nil
			if current_page?(url_for(:controller => 'aplcat_parameters', :action => 'edit'))
				@scenario_name = Scenario.find(params[:scenario_id]).name
				true
			elsif request.url.include?(url_for("/aplcat_parameters"))
				@scenario_name = Scenario.find(params[:scenario_id]).name
				true
			elsif request.url.include?(url_for("/grazing_parameters")) || request.url.include?(url_for("/supplement_parameters"))
				@scenario_name = Scenario.find(params[:scenario_id]).name
				true
			end
		else
			false
		end
	end

	def result_submenu
		if request.url.include?(url_for('by_soils'))
			true
		elsif request.url.include?(url_for('annual_charts'))
			true
		elsif request.url.include?(url_for('monthly_charts'))
			true
		elsif request.url.include?(url_for("/summary"))
			true
		elsif request.url.include?(url_for("/results"))
			true
		else
			false
		end
	end

	def aplcats_submenu
		if request.url.include?(url_for('aplcat_parameters'))
			true
		elsif request.url.include?(url_for('grazing_parameters')) || request.url.include?(url_for('supplement_parameters'))
			true
		else
			false
		end
	end

	def apex_files_submenu
		if request.url.include?(url_for('apex'))
			true
		elsif request.url.include?(url_for('subareas'))
			true
		elsif request.url.include?(url_for('site'))
			true
		elsif request.url.include?(url_for('soils'))
			true
		elsif request.url.include?(url_for('operations'))
			true
		else
			false
		end
	end

	def watershed_submenu
		if (request.url.include?(url_for('results')) && request.url.include?(url_for('simulation=Watershed')) || request.url.include?(url_for('watersheds')))
			session[:simulation] = 'watershed'
			true
		else
			false
		end
	end

  def download_apex_files
    client = Savon.client(wsdl: URL_Weather)
    response = client.call(:download_apex_folder, message: {"NTTFilesFolder" => APEX_FOLDER + "/APEX", "session1" => session[:session_id], "type" => "apex"})
    path = response.body[:download_apex_folder_response][:download_apex_folder_result]
	  file_name = path.split("\\")
	  path = File.join(DOWNLOAD, file_name[2])
	  require 'open-uri'
	  File.open(DOWNLOAD + "/" + file_name[2], "wb") do |saved_file|
	    # the following "open" is provided by open-uri
	    open("http://nn.tarleton.edu//download/" + file_name[2], "rb") do |read_file|
	      saved_file.write(read_file.read)
      end
			send_file path, :type => "application/xml", :x_sendfile => true
  	end
  end

  def download_aplcat_files
    client = Savon.client(wsdl: URL_Weather)
    response = client.call(:download_apex_folder, message: {"NTTFilesFolder" => APEX_FOLDER + "/APLCAT", "session1" => session[:session_id], "type" => "aplcat"})
    path = response.body[:download_apex_folder_response][:download_apex_folder_result]
	  file_name = path.split("\\")
	  path = File.join(DOWNLOAD, file_name[2])
	  require 'open-uri'
	  File.open(DOWNLOAD + "/" + file_name[2], "wb") do |saved_file|
	    # the following "open" is provided by open-uri
	    open("http://nn.tarleton.edu//download/" + file_name[2], "rb") do |read_file|
	      saved_file.write(read_file.read)
      end
			send_file path, :type => "application/xml", :x_sendfile => true
  	end
  end

end
