require __dir__+'/../../setup'

require __dir__+'/../../helpers/explorer_helper'
include ExplorerHelper

mainnet_stream = '6c54e5cdfd'
testnet_stream = 'f7395c0146'

timeout = 30

def generate_stats_table(data)
	total_assets = data['numOfAssets'] if data
	total_tx = data['numOfCCTransactions'] if data
	total_holders = data['numOfHolders'] if data

	point = {"leaderboard": [
		{"name": "Assets", "value": total_assets.to_i},
		{"name": "Tx", "value": total_tx.to_i},
		{"name": "Holders", "value": total_holders.to_i}
		]}	
end


begin
  Timeout::timeout(timeout) do
		# main_stats = HTTParty.get(explorer_api(:mainnet)+'getmainstats')
		mainnet_stats=query_explorer_api('getmainstats',network: :mainnet)
		testnet_stats=query_explorer_api('getmainstats',network: :testnet)

		mainnet_point = generate_stats_table(mainnet_stats)
		testnet_point = generate_stats_table(testnet_stats)

		UPDATE.push_line(mainnet_stream,mainnet_point)
		UPDATE.push_line(testnet_stream,testnet_point)
  end
rescue Timeout::Error
	p "Explorer call timed out after #{timeout} seconds"
end	


