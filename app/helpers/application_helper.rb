module ApplicationHelper
	def current_page(path)
	  "active" if request.url.include?(path) end
		#uniquely coded the welcome class because the auto redirect in welcomes controller prevents current_page from working on welcomes_path(0)
		def active_welcome?
			if controller.env["REQUEST_PATH"] == "/welcomes/0"
				"active"
			end
		end

		def field_submenu
			if request.url.include?(url_for('/fields')) && (request.parameters[:caller_id] != "FEM")
				true
			elsif request.parameters[:caller_id] == "FEM" && request.parameters[:field_id] != nil
				true
			elsif request.url.include?(url_for("/fem_generals")) || request.url.include?(url_for("/fem_feeds")) || request.url.include?(url_for("/fem_machines")) || request.url.include?(url_for("/fem_facilities"))
				true
			elsif request.url.include?(url_for("/weathers"))
				true
			elsif current_page?(url_for(:controller => 'apex_controls', :action => 'index'))
				true
			elsif current_page?(url_for(:controller => 'apex_parameters', :action => 'index'))
				true
			elsif request.url.include?(url_for("/scenarios")) && request.parameters[:caller_id] == "NTT"
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
			elsif request.url.include?(url_for("/supplement_parameters")) || request.url.include?(url_for("/animal_transports"))
				true
			elsif current_page?(url_for(controller: 'soils', :action => 'index'))
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
			#elsif params[:scenario_id] != nil
				#if request.url.include?(url_for("/aplcat_parameters"))
					#@scenario_name = Scenario.find(params[:scenario_id]).name
					#true
				#elsif request.url.include?(url_for("/grazing_parameters")) || request.url.include?(url_for("/supplement_parameters")) || request.url.include?(url_for("/animal_transports"))
					#@scenario_name = Scenario.find(params[:scenario_id]).name
					#true
				#end
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
			#elsif request.url.include?("fem")
				#true
			elsif request.url.include?(url_for("/results")) && !(request.url.include?("fem")|| request.url.include?("aplcat"))
				true
			else
				false
			end
		end

		def fem_submenu
			if request.url.include?(url_for('general'))
				true
			elsif request.url.include?(url_for('feed'))
				true
			elsif request.url.include?(url_for("machine"))
				true
			elsif request.url.include?(url_for("facilities"))
				true
			elsif request.url.include?(url_for("scenarios")) && request.parameters[:caller_id] == "FEM"
				true
			elsif request.url.include?(url_for("fem_results"))
				true
			else
				false
			end
		end
		
		#def aplcats_submenu
			#if request.url.include?(url_for('aplcat_parameters')) || request.url.include?(url_for('operation')) || request.url.include?(url_for('bmps'))
				#true
			#elsif request.url.include?(url_for('grazing_parameters')) || request.url.include?(url_for('supplement_parameters'))  || request.url.include?(url_for('animal_transports'))
				#true
			#elsif request.url.include?(url_for("scenarios")) && request.parameters[:caller_id] == "APLCAT"
				#true
			#else
				#false
			#end
		#end

		def aplcats_sub_submenu
			if request.url.include?(url_for('grazing_parameters')) || request.url.include?(url_for('supplement_parameters')) || request.url.include?(url_for('aplcat_parameters'))  || request.url.include?(url_for('animal_transports'))
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
			elsif (request.url.include?(url_for('results')) && session[:simulation] == 'watershed')
				true
			else
				false
			end
		end

	  	def download_apex_files
		    client = Savon.client(wsdl: URL_SoilsInfo)
		    response = client.call(:download_apex_folder, message: {"NTTFilesFolder" => APEX_FOLDER + "/APEX", "session1" => session[:session_id], "type" => "apex"})
		    path_source = response.body[:download_apex_folder_response][:download_apex_folder_result]
			if path_source.nil?
				flash[:info] = "Error: No simulations exist in this session. " +
												"Please run a simulation before downloading APEX files."
				redirect_to project_field_scenarios_path(@project, @field,:caller_id => "NTT")
			else
				file_name = path_source.split("\\")
				path = File.join(DOWNLOAD, file_name[2])
				require 'open-uri'
				File.open(path, "wb") do |saved_file|
			    # the following "open" is provided by open-uri
				    open("http://ntt.ama.cbntt.org//NTTRails//NNRestService.ashx?test=zip&path=" + path_source, "rb") do |read_file|
				    #open("http://nn.tarleton.edu//NTTRails//NNRestService.ashx?test=zip&path=" + path_source + ".zip", "rb") do |read_file|
				      saved_file.write(read_file.read)
			      	end
					send_file path, :type => "application/xml", :x_sendfile => true
				end
			end
	  	end

	  	def download_fem_files
		    client = Savon.client(wsdl: URL_SoilsInfo)
		    response = client.call(:download_fem_folder, message: {"NTTFilesFolder" => FEM_FOLDER + "/FEM", "session1" => session[:session_id], "type" => "fem"})
		    path_source = response.body[:download_fem_folder_response][:download_fem_folder_result]
			if path_source.nil?
				flash[:info] = "Error: No simulations exist in this session. " +
												"Please run a simulation before downloading APLCAT files."
				redirect_to project_field_scenarios_path(@project, @field,:caller_id => "FEM")
			else
			    file_name = path_source.split("\\")
			    path = File.join(DOWNLOAD, file_name[2])
			    require 'open-uri'
			    File.open(path, "wb") do |saved_file|
					# the following "open" is provided by open-uri
				    open("http://ntt.ama.cbntt.org//NTTRails//NNRestService.ashx?test=zip&path=" + path_source, "rb") do |read_file|
				    #open("http://nn.tarleton.edu//NTTRails//NNRestService.ashx?test=zip&path=" + path_source + ".zip", "rb") do |read_file|
				      saved_file.write(read_file.read)
			      	end
					send_file path, :type => "application/xml", :x_sendfile => true
				end
	  		end
		end

	  	def download_aplcat_files
		    client = Savon.client(wsdl: URL_SoilsInfo)
		    response = client.call(:download_aplcat_folder, message: {"NTTFilesFolder" => APLCAT_FOLDER + "/APLCAT", "session1" => session[:session_id], "type" => "aplcat"})
		    path_source = response.body[:download_aplcat_folder_response][:download_aplcat_folder_result]
			if path_source.nil?
				flash[:info] = "Error: No simulations exist in this session. " +
												"Please run a simulation before downloading APLCAT files."
				redirect_to project_field_scenarios_path(@project, @field,:caller_id => "NTT")
			else
			    file_name = path_source.split("\\")
			    path = File.join(DOWNLOAD, file_name[2])
			    require 'open-uri'
			    File.open(path, "wb") do |saved_file|
					# the following "open" is provided by open-uri
				    open("http://ntt.ama.cbntt.org//NTTRails//NNRestService.ashx?test=zip&path=" + path_source, "rb") do |read_file|
				    #open("http://nn.tarleton.edu//NTTRails//NNRestService.ashx?test=zip&path=" + path_source + ".zip", "rb") do |read_file|
				      saved_file.write(read_file.read)
			      	end
					send_file path, :type => "application/xml", :x_sendfile => true
				end
	  		end
		end

	  	def download_dndc_files
		    client = Savon.client(wsdl: URL_SoilsInfo)
		    response = client.call(:download_dndc_folder, message: {"NTTFilesFolder" => APLCAT_FOLDER + "/DNDC", "session1" => session[:session_id], "type" => "aplcat"})
		    path_source = response.body[:download_dndc_folder_response][:download_dndc_folder_result]
			if path_source.nil?
				flash[:info] = "Error: No simulations exist in this session. " +
												"Please run a simulation before downloading DNDC files."
				redirect_to project_field_scenarios_path(@project, @field,:caller_id => "NTT")
			else
			    file_name = path_source.split("\\")
			    path = File.join(DOWNLOAD, file_name[2])
			    require 'open-uri'
			    File.open(path, "wb") do |saved_file|
					# the following "open" is provided by open-uri
				    open("http://ntt.ama.cbntt.org//NTTRails//NNRestService.ashx?test=zip&path=" + path_source, "rb") do |read_file|
				    #open("http://nn.tarleton.edu//NTTRails//NNRestService.ashx?test=zip&path=" + path_source + ".zip", "rb") do |read_file|
				      saved_file.write(read_file.read)
			      	end
					send_file path, :type => "application/xml", :x_sendfile => true
				end
	  		end
		end
end
