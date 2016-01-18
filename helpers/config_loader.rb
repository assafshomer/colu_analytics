
require 'ostruct'

module ConfigLoader
	def load_app_config
	  user_configs = read_yaml_file
	  environment_configs = ENV || {}
	  
	  config_order = [user_configs, environment_configs]

	  configs = config_order.inject { |a, b| a.merge(b) }	  
	  OpenStruct.new(configs.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo})
	end

	def read_yaml_file
		YAML.load(File.read(File.expand_path('../../config.yml', __FILE__)))
	end	
end