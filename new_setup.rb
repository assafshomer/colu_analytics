require __dir__+'/leftronic'
require 'yaml'
require 'json'
require 'time'
require 'httparty'
require __dir__+'/helpers/views_helper'
  
# APP_CONFIG = YAML.load(File.read(File.expand_path('../config.yml', __FILE__)))
load_app_config

EXPLORER_API = APP_CONFIG['explorer_api_url']
KEY = APP_CONFIG['leftronic_key']
URL = 'https://www.leftronic.com/customSend/'
CURL = 'curl -i -X POST -k -d'
UPDATE = Leftronic.new KEY


def load_app_config
  user_configs = read_yaml_file
  environment_configs = ENV || {}
  
  config_order = [user_configs, environment_configs]

  configs = config_order.inject { |a, b| a.merge(b) }
  OpenStruct.new(configs.symbolize_keys)
end

def read_yaml_file
	YAML.load(File.read(File.expand_path('../config.yml', __FILE__)))
end