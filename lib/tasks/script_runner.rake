#namespace :script_runner do
#	desc "Runs hello worls R program"
#	task :hello_world_r do
#		debugger
#	    puts "running R!"
#	    filepath = Rails.root.join("lib", "external_scripts", "hello_world.R")
#	    @output = `Rscript --vanilla #{filepath}`
#	end

#	desc "Runs an external ruby script"
#	task :run_ruby => :environment do
#		puts "running ruby!"
#		filepath = Rails.root.join('lib', 'external_scripts', 'ruby_script.rb')
#		@output = `ruby #{filepath}`
#	end
#end