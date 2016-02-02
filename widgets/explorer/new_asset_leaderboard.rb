require __dir__+'/../../setup'

require __dir__+'/../../helpers/explorer_helper'
include ExplorerHelper
require __dir__+'/../../helpers/piwik_helper'
include PiwikHelper

assets_stream = '00c86ecdc4'
number_of_assets = 3
number_of_days = 1
start_days_past = 0
debug = false

# raw_data = get_cc_tx_last_days(number_of_days-1,start_days_past,debug)

# ordered_asset_ids = order_asset_ids(raw_data).first(number_of_assets)
# p "ordered_asset_ids: #{ordered_asset_ids}"

curdate = Time.at(Time.now.to_i)
curdate = Time.parse('2016-02-01')
number_of_piwik_results = 9999
method = "Live.getLastVisitsDetails"
raw = piwik_data_during_day(curdate, method: method, debug: false,limit: number_of_piwik_results)
visits = JSON.parse(raw)
parsed_piwik_visits = parse_visits(visits)

# asset_id = 'U6b18ZCXESJVmnbEMp4DtR7X6Hce14bS8NQsE'

# p pick_piwik_data_for_asset_id(parsed_piwik_visits,asset_id)

# p "parsed_piwik_visits: #{parsed_piwik_visits}"

ordered_asset_ids = [{:LFMyMCabNPP1hqcRHRy9o71PpMKqzAGyEKjfU=>6}, {:LHCaK3nnpmiHRHLAaSUtTXX3tyXt9DqTURsdr=>5}, {:U6b18ZCXESJVmnbEMp4DtR7X6Hce14bS8NQsE=>3}]

# ordered_asset_ids.each do |kvp|
# 	asset_id = kvp.keys.first
# 	p "asset_id: #{asset_id}"
# 	p pick_piwik_data_for_asset_id(parsed_piwik_visits,asset_id.to_s)
# end


data = ordered_asset_ids.map do |data_point|
	max_length = 25
	asset_id = data_point.keys.first
	short_asset_id = asset_id[0..20]+'...'
	metadata = get_asset_metadata(asset_id)
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
	result[:frequency] = frequency
	result[:display_name] = display_name
	result[:issuer_name] = issuer_name
	result[:asset_desc] = asset_desc
	p "result #{result}"
	result
end

# p "data: #{data}"

html = prepare_new_asset_leaderboard(data)

UPDATE.push_html assets_stream, html