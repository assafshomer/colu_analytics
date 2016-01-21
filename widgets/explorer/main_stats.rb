require __dir__+'/../../setup'

require __dir__+'/../../helpers/explorer_helper'
include ExplorerHelper

stream = '6c54e5cdfd'

begin
  Timeout::timeout(30) do
		main_stats = HTTParty.get(EXPLORER_API+'getmainstats')
		total_assets = main_stats.parsed_response['numOfAssets']
		total_tx = main_stats.parsed_response['numOfCCTransactions']
		total_holders = main_stats.parsed_response['numOfHolders']

		point = {"leaderboard": [
			{"name": "Assets", "value": total_assets},
			{"name": "Tx", "value": total_tx},
			{"name": "Holders", "value": total_holders}
			]}

		UPDATE.clear(stream)
		UPDATE.push_line(stream,point)		
  end
rescue Timeout::Error
	p "Explorer call timed out"
end	


