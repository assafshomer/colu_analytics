
require 'ostruct'

module ConfigLoader
	DEFAULT_CONFIGS = "config.defaults.yml"
  USER_CONFIGS = "config.yml"
	def load_app_config
		default_configs = read_yaml_file(DEFAULT_CONFIGS) || {}
	  user_configs = read_yaml_file(USER_CONFIGS) || {}
	  environment_configs = ENV || {}
	  
	  config_order = [default_configs,user_configs,environment_configs]

	  configs = config_order.inject { |a, b| a.merge(b) }	
	  OpenStruct.new(symbolize_keys(configs))
	end

	def read_yaml_file(file_name)
		path = File.expand_path("../../#{file_name}", __FILE__)
		if File.exists?(path)
			YAML.load(File.read(path))	
		end		
	end

	def symbolize_keys(hash)
		return hash unless hash.class == 'Hash'
		hash.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
	end
end