require __dir__+'/../../setup'

require __dir__+'/../../helpers/explorer_helper'
include ExplorerHelper
require __dir__+'/../../helpers/leaderboard_helper'
include LeaderboardHelper

streams={mainnet:{issuance:'wbCblg7t',transfer:'AIceGGMQ'},			 		testnet:{issuance:'82934b53b9',transfer:'932cbb34fe'}}

number_of_assets = 6
number_of_hours = 24
start_days_past = 0
debug = false
timeout = {mainnet: 30, testnet: 60}

[:mainnet, :testnet].each do |network|
	# next if network == :mainnet
	print_box "Processing #{network}"
	begin
	  Timeout::timeout(timeout[network]) do			
			raw_data = get_cc_tx_last_hours(limit: number_of_hours,offset: start_days_past*24,debug: debug,network: network)
			ordered_asset_ids = order_asset_ids(raw_data)
			[:issuance, :transfer].each do |txtype|
				print_box("Processing #{txtype}")
				raw_txtype_data = raw_data.select{|d| d[:type] == txtype.to_s}
				txtype_data = group_by_hour(raw_txtype_data)
				parsed_txtype_data = txtype_data.map do |k,v|	
					hash = {"number" => v.count, "timestamp" => Time.parse(k).to_i}
					JSON.parse(hash.to_json)
				end
				p parsed_txtype_data if debug
				stream = streams[network][txtype]
				UPDATE.clear(stream)
				UPDATE.push_line(stream,parsed_txtype_data)	
			end		
	  end
	rescue Timeout::Error
		p "#{filename(__FILE__).upcase} (#{network.upcase}) timed out after #{timeout} seconds"
	end		
end