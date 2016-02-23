require __dir__+'/../../setup'

require __dir__+'/../../helpers/explorer_helper'
include ExplorerHelper

streams = {mainnet: '6c54e5cdfd', testnet: 'f7395c0146'}
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

[:mainnet, :testnet].each do |network|
	# next if network == :mainnet
	print_box("Processing #{network}")	
	begin
	  Timeout::timeout(timeout) do			
			stats=query_explorer_api('getmainstats',network: network)
			point = generate_stats_table(stats)
			stream = streams[network]
			UPDATE.clear(stream)
			UPDATE.push_line(stream,point)  		
	  end
	rescue Timeout::Error
		p "#{network} Explorer call timed out after #{timeout} seconds"
	end		
end