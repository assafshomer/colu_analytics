require __dir__+'/../../setup'

require __dir__+'/../../helpers/explorer_helper'
include ExplorerHelper

stream = '6c54e5cdfd'
UPDATE.clear(stream)
timeout = 30
main_stats = nil

begin
  Timeout::timeout(timeout) do
		main_stats = HTTParty.get(EXPLORER_API+'getmainstats')
  end
rescue Timeout::Error
	p "Explorer call timed out after #{timeout} seconds"
end	

total_assets = main_stats.parsed_response['numOfAssets'] if main_stats
total_tx = main_stats.parsed_response['numOfCCTransactions'] if main_stats
total_holders = main_stats.parsed_response['numOfHolders'] if main_stats

point = {"leaderboard": [
	{"name": "Assets", "value": total_assets.to_i},
	{"name": "Tx", "value": total_tx.to_i},
	{"name": "Holders", "value": total_holders.to_i}
	]}

UPDATE.push_line(stream,point)