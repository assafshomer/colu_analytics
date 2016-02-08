require __dir__+'/../../setup'

require __dir__+'/../../helpers/leaderboard_helper'
include LeaderboardHelper

mainnet_asset_stream = '00c86ecdc4'
testnet_asset_stream = '717574cf8b'

mainnet = true
testnet = false

number_of_assets = 12
number_of_days = 1
start_days_past = 0
debug = false

timeout = 120

begin
  Timeout::timeout(timeout) do

  	if mainnet
			mainnet_data = collect_asset_leaderboard_data(
				number_of_assets: number_of_assets,
				number_of_days: number_of_days,
				start_days_past: start_days_past,
				debug: debug,
				network: :mainnet
				)
			mainnet_html = prepare_asset_leaderboard(mainnet_data,
				debug: debug, 
				network: :mainnet
				)
			UPDATE.push_html mainnet_asset_stream, mainnet_html
  	end

  	if testnet
			testnet_data = collect_asset_leaderboard_data(
				number_of_assets: number_of_assets,
				number_of_days: number_of_days,
				start_days_past: start_days_past,
				debug: debug,
				network: :testnet
				)
			testnet_html = prepare_asset_leaderboard(testnet_data,
				debug: debug, 
				network: :testnet
				)
			UPDATE.push_html testnet_asset_stream, testnet_html  		
  	end

  end
rescue Timeout::Error
	p "Explorer API call timed out after #{timeout} seconds"
end