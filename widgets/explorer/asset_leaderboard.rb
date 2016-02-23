require __dir__+'/../../setup'

require __dir__+'/../../helpers/leaderboard_helper'
include LeaderboardHelper

streams = {mainnet: '00c86ecdc4', testnet: '717574cf8b'}
number_of_assets = 12
number_of_hours = 24
start_hours_past = 0
debug = false

timeout = {mainnet: 120, testnet: 180}

[:mainnet, :testnet].each do |network|
	# next if network == :mainnet
	print_box("Processing #{network}")
	begin
	  Timeout::timeout(timeout[network]) do
		data = collect_asset_leaderboard_data_by_hour(
			number_of_assets: number_of_assets,
			number_of_hours: number_of_hours,
			start_hours_past: start_hours_past,
			debug: debug,
			network: network
			)
		html = prepare_asset_leaderboard(data,
			debug: debug, 
			network: network
			)
		stream = streams[network]
		UPDATE.clear(stream) if debug
		UPDATE.push_html stream, html
  end
	rescue Timeout::Error
		p "#{network} Explorer API call timed out after #{timeout[network]} seconds"
	end
end