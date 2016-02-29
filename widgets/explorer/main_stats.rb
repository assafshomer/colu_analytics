require __dir__+'/../../setup'

require __dir__+'/../../helpers/explorer_helper'
include ExplorerHelper

streams = {mainnet: '6c54e5cdfd', testnet: 'f7395c0146'}
timeout = 30

[:mainnet, :testnet].each do |network|
	# next if network == :mainnet
	print_box("Processing #{network}")	
	begin
	  Timeout::timeout(timeout) do			
			stats=query_explorer_api('getmainstats',network:network)
			point = generate_stats_table(stats)
			stream = streams[network]
			UPDATE.clear(stream)
			UPDATE.push_line(stream,point)  		
	  end
	rescue Timeout::Error
		p "#{filename(__FILE__).upcase} (#{network.upcase}) timed out after #{timeout} seconds"
	end		
end