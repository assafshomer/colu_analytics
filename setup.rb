require __dir__+'/leftronic'
require 'yaml'
require 'json'
require 'time'
require 'httparty'
require __dir__+'/helpers/views_helper'
require __dir__+'/helpers/explorer_helper'
include ExplorerHelper

  
APP_CONFIG = YAML.load(File.read(File.expand_path('../config.yml', __FILE__)))

EXPLORER_API = APP_CONFIG['explorer_api_url']
KEY = APP_CONFIG['leftronic_key']
URL = 'https://www.leftronic.com/customSend/'
CURL = 'curl -i -X POST -k -d'
UPDATE = Leftronic.new KEY
