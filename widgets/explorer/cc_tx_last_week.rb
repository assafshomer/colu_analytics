require __dir__+'/../../setup'

require __dir__+'/../../helpers/explorer_helper'
include ExplorerHelper

streams = {mainnet: 'ZfLVeunS', testnet: '07f106fec5'}
num_days = 7
timeout = 60

[:mainnet, :testnet].each do |network|
	# next if network == :mainnet
	print_box("Processing #{network}")	
	begin
	  Timeout::timeout(timeout) do			
			data = number_of_cc_tx_by_days(num_days: num_days, network: network)
			parsed_data = data.map do |x|	
				hash = {"number" => x["txsSum"], "timestamp" => x["from"]/1000}
				JSON.parse(hash.to_json)
			end
			stream = streams[network]
			UPDATE.clear(stream)
			UPDATE.push_line(stream,parsed_data)  		
	  end
	rescue Timeout::Error
		p "#{filename(__FILE__).upcase} (#{network.upcase}) timed out after #{timeout} seconds"
	end		
end