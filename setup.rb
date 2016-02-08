require __dir__+'/leftronic'
require 'yaml'
require 'json'
require 'time'
require 'httparty'
require __dir__+'/helpers/views_helper'
include ViewsHelper
require __dir__+'/helpers/date_helper'
include DateHelper
require __dir__+'/helpers/config_loader'
include ConfigLoader
require 'byebug'

# APP_CONFIG = YAML.load(File.read(File.expand_path('../config.yml', __FILE__)))
APP_CONFIG = load_app_config

KEY = APP_CONFIG['leftronic_key']
URL = 'https://www.leftronic.com/customSend/'
CURL = 'curl -i -X POST -k -d'
UPDATE = Leftronic.new KEY


