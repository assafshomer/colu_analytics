require __dir__+'/../../setup'

require __dir__+'/../../helpers/explorer_helper'
include ExplorerHelper

# stream = 'H2L1ArR6'
stream = 'ciEHPc2x'
network = :testnet
timeout = 90

begin
  Timeout::timeout(timeout) do
		data = []
		12.times do |month|
			month_data = number_of_cc_tx_in_month(offset: month,network: network)
			data << month_data
		end
		p data
		parsed_data = data.map do |d|	
			x = d.first
			hash = {"number" => x["txsSum"], "timestamp" => x["from"]/1000}
			JSON.parse(hash.to_json)
		end
		p parsed_data
		UPDATE.clear(stream)
		UPDATE.push_line(stream,parsed_data)	
  end
rescue Timeout::Error
	p "Explorer call timed out after #{timeout} seconds"
end

