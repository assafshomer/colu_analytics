require __dir__+'/../../setup'

require __dir__+'/../../helpers/engine_helper'
include EngineHelper

streams={mainnet:{total: '759f20c696',average: 'snLpM8qC'}}
timeout = {mainnet: 30, testnet: 30}
number_of_days = 9
debug = true

[:mainnet, :testnet,:dev].each do |network|
	next unless network == :mainnet
	print_box "Processing #{network}"
	begin
	  Timeout::timeout(timeout[network]) do
			result = finance_stats_bar(number_of_days)
			[:total, :average].each do |ta|
				stream = streams[network][ta]
				UPDATE.clear(stream)
				UPDATE.push_line(stream,result[ta])				
			end
		end
	rescue Timeout::Error
		p "#{network} Engine call timed out after #{timeout[network]} seconds"
	end		
end