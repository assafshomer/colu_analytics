require __dir__+'/../../setup'

require __dir__+'/../../helpers/explorer_helper'
include ExplorerHelper

mainnet_stream = 'ZfLVeunS'
testnet_stream = '07f106fec5'

num_days = 7

timeout = 60
[:mainnet, :testnet].each do |network|
	begin
	  Timeout::timeout(timeout) do
			stream = eval("#{network}_stream")
			data = number_of_cc_tx_by_days(num_days: num_days, network: network)
			parsed_data = data.map do |x|	
				hash = {"number" => x["txsSum"], "timestamp" => x["from"]/1000}
				JSON.parse(hash.to_json)
			end
			UPDATE.clear(stream)
			UPDATE.push_line(stream,parsed_data)  		
	  end
	rescue Timeout::Error
		p "#{network} Explorer call timed out after #{timeout} seconds"
	end		
end


