require __dir__+'/../../setup'

require __dir__+'/../../helpers/leaderboard_helper'
include LeaderboardHelper

dev_stream = 'OHcgwTAF'

number_of_assets = 12
number_of_hours = 24
start_hours_past = 0
debug = true

timeout = 120

begin
  Timeout::timeout(timeout) do

		stream = dev_stream
		data = collect_asset_leaderboard_data_by_hour(
			number_of_assets: number_of_assets,
			number_of_hours: number_of_hours,
			start_hours_past: start_hours_past,
			debug: debug,
			network: :mainnet
			)
		html = prepare_asset_leaderboard(data,
			debug: debug, 
			network: :mainnet
			)
		UPDATE.clear(stream)
		UPDATE.push_html stream, html

  end
rescue Timeout::Error
	p "Explorer API call timed out after #{timeout} seconds"
end