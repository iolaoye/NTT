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
		if current_page?(url_for(:controller => 'weathers', :action => 'edit'))
			true
		elsif current_page?(url_for(:controller => 'soils', :action => 'list'))
			true
		elsif current_page?(url_for(:controller => 'scenarios', :action => 'list'))
			true
		elsif current_page?(url_for(:controller => 'results', :action => 'index'))
			true
		elsif current_page?(url_for(:controller => 'apex_controls', :action => 'index'))
			true
		elsif current_page?(url_for(:controller => 'operations', :action => 'list'))
			true
		elsif current_page?(url_for(:controller => 'operations', :action => 'new'))
			true
		elsif current_page?(url_for(:controller => 'bmps', :action => 'list'))
			true
		else
			false
		end
	end

	def scenario_submenu
		if current_page?(url_for(:controller => 'operations', :action => 'list'))
			true
		elsif current_page?(url_for(:controller => 'bmps', :action => 'list'))
			true
		else
			false
		end
	end

end
