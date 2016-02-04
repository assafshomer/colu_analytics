require __dir__+'/../../setup'

require __dir__+'/../../helpers/explorer_helper'
include ExplorerHelper
require __dir__+'/../../helpers/piwik_helper'
include PiwikHelper

assets_stream = '00c86ecdc4'
number_of_assets = 7
number_of_days = 1
start_days_past = 0
debug = false

raw_data = get_cc_tx_last_days(number_of_days-1,start_days_past,debug)

ordered_asset_ids = order_asset_ids(raw_data).first(number_of_assets)
# p "ordered_asset_ids: #{ordered_asset_ids}"

curdate = Time.at(Time.now.to_i)
number_of_piwik_results = 9999
method = "Live.getLastVisitsDetails"
raw = piwik_data_during_day(curdate, method: method, debug: false,limit: number_of_piwik_results)
visits = JSON.parse(raw)
parsed_piwik_visits = parse_visits(visits)

data = ordered_asset_ids.map do |data_point|
	max_length = 20
	asset_id = data_point.keys.first
	short_asset_id = asset_id[0..15]+'...'
	metadata = get_asset_metadata(asset_id)
	full_name = metadata ? metadata['assetName'].to_s : asset_id
	display_name = metadata ? metadata['assetName'].to_s : short_asset_id
	display_name = display_name.empty? ? short_asset_id : display_name
	display_name = display_name.length > max_length ? display_name[0..max_length]+'...' : display_name
	issuer_name = metadata ? metadata['issuer'] : ''
	asset_desc = metadata ? metadata['description'] : ''
	p "name: #{display_name}, issuer: #{issuer_name}, desc: #{asset_desc}, asset_id: #{asset_id}"	
	frequency = data_point[asset_id]
	piwik_data = pick_piwik_data_for_asset_id(parsed_piwik_visits,asset_id)
	# p "piwik_data: #{piwik_data}"
	result = piwik_data || {}
	
	country_full = result[:country].to_s
	country = shorten_country(country_full)
	result[:country] = country
	result[:country_full] = country_full
	
	city = result[:city].to_s
	result[:city] = city.empty? ? 'Unknown' : city

	result[:asset_id] ||= asset_id
	result[:frequency] = frequency
	result[:display_name] = display_name
	result[:full_name] = full_name
	result[:issuer_name] = issuer_name
	result[:asset_desc] = asset_desc
	p "result #{result}"
	result
end



# p "data: #{data}"

html = prepare_new_asset_leaderboard(data)

UPDATE.push_html assets_stream, html