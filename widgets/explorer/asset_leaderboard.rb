require __dir__+'/../../setup'

require __dir__+'/../../helpers/leaderboard_helper'
include LeaderboardHelper

mainnet_asset_stream = '00c86ecdc4'
testnet_asset_stream = '717574cf8b'

mainnet = true
testnet = true

number_of_assets = 12
number_of_hours = 24
start_hours_past = 0
debug = false

timeout = 120

begin
  Timeout::timeout(timeout) do

  	if mainnet
  		stream = mainnet_asset_stream
			mainnet_data = collect_asset_leaderboard_data_by_hour(
				number_of_assets: number_of_assets,
				number_of_hours: number_of_hours,
				start_hours_past: start_hours_past,
				debug: debug,
				network: :mainnet
				)
			html = prepare_asset_leaderboard(mainnet_data,
				debug: debug, 
				network: :mainnet
				)
			UPDATE.clear(stream) if debug
			UPDATE.push_html stream, html
  	end

  	if testnet
  		stream = testnet_asset_stream
			testnet_data = collect_asset_leaderboard_data(
				number_of_assets: number_of_assets,
				number_of_hours: number_of_hours,
				start_hours_past: start_hours_past,
				debug: debug,
				network: :testnet
				)
			html = prepare_asset_leaderboard(testnet_data,
				debug: debug, 
				network: :testnet
				)
			UPDATE.clear(stream) if debug
			UPDATE.push_html stream, html
  	end

  end
rescue Timeout::Error
	p "Explorer API call timed out after #{timeout} seconds"
end