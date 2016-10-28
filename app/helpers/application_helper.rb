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

end
