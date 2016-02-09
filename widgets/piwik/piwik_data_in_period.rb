require __dir__+'/../../setup'

require __dir__+'/../../helpers/piwik_helper'
include PiwikHelper

# stream = 'IJ5qcBMI'

number_of_results = 9999
method = "Live.getLastVisitsDetails"
number_of_days = 1
days_offset = 3
raw = piwik_data_during_period(
	method: method, 
	debug: false,
	filter: number_of_results, 
	num_days: number_of_days -1,
	days_offset: days_offset
	)

visits = raw.class == String ? JSON.parse(raw) : raw

asset_data = parse_visits(visits)

asset_id = 'LFu6pNp5FLHQu1RERkYEjPjxFZLD3zNJAbhYz'

p pick_piwik_data_for_asset_id(asset_data,asset_id)

