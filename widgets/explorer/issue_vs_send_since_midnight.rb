require __dir__+'/../../setup'

require __dir__+'/../../helpers/explorer_helper'
include ExplorerHelper
require __dir__+'/../../helpers/leaderboard_helper'
include LeaderboardHelper


issuance_stream = 'wbCblg7t'
transfer_stream = 'AIceGGMQ'
# assets_stream = 'aEu4sfdm'

number_of_assets = 6
number_of_days = 1
start_days_past = 0
debug = false
network = :mainnnet
raw_data = get_cc_tx_last_days(limit: number_of_days-1,offset: start_days_past,debug: debug,network: network)
# File.write("#{__dir__}/../../data/#{File.basename(__FILE__,".*")}",raw_data)
File.write("#{__dir__}/../../data/raw_tx_data",raw_data) if debug

issuance_raw_data = raw_data.select{|d| d[:type] == 'issuance'}
transfer_raw_data = raw_data.select{|d| d[:type] == 'transfer'}
ordered_asset_ids = order_asset_ids(raw_data)

issuance_data = group_by_hour(issuance_raw_data)
transfer_data = group_by_hour(transfer_raw_data)

parsed_issuance_data = issuance_data.map do |k,v|	
	hash = {"number" => v.count, "timestamp" => Time.parse(k).to_i}
	JSON.parse(hash.to_json)
end
parsed_transfer_data = transfer_data.map do |k,v|	
	hash = {"number" => v.count, "timestamp" => Time.parse(k).to_i}
	JSON.parse(hash.to_json)
end

p parsed_issuance_data if debug
UPDATE.clear(issuance_stream)
UPDATE.push_line(issuance_stream,parsed_issuance_data)

p parsed_transfer_data if debug
UPDATE.clear(transfer_stream)
UPDATE.push_line(transfer_stream,parsed_transfer_data)


# asset_data = ordered_asset_ids.map do |e| 
# 	{name: e.keys.first, value: e[e.keys.first]}
# end
# point = {"leaderboard": asset_data.first(5) }
# UPDATE.push_line(assets_stream,point)

# ordered_asset_ids = order_asset_ids(raw_data).first(number_of_assets)
# html = prepare_simple_asset_leaderboard(ordered_asset_ids)
# # UPDATE.clear(assets_stream)
# UPDATE.push_html assets_stream, html