require __dir__+'/leftronic'
require 'yaml'
require 'json'
require 'time'
require 'httparty'
require __dir__+'/helpers/views_helper'
require __dir__+'/helpers/config_loader'
include ConfigLoader
require 'byebug'
# APP_CONFIG = YAML.load(File.read(File.expand_path('../config.yml', __FILE__)))
APP_CONFIG = load_app_config

EXPLORER_API = APP_CONFIG['explorer_api_url']
CC_API = APP_CONFIG['cc_api_url']
KEY = APP_CONFIG['leftronic_key']
URL = 'https://www.leftronic.com/customSend/'
CURL = 'curl -i -X POST -k -d'
UPDATE = Leftronic.new KEY


