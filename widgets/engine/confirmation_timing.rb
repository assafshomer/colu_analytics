require __dir__+'/../../setup'

require __dir__+'/../../helpers/engine_helper'
include EngineHelper

streams={mainnet:{average: 'H7cuSzhI',maximal: 'fReTAmuf'}}
timeout = {mainnet: 30, testnet: 30}
number_of_days = 9
debug = true

[:mainnet].each do |network|
	print_box "Processing #{network}"
	begin
	  Timeout::timeout(timeout[network]) do
			result = confirmation_stats(number_of_days)
			print_box result, "result"
			[:average, :maximal].each do |ta|
				stream = streams[network][ta]
				UPDATE.clear(stream)
				UPDATE.push_line(stream,result[ta])				
			end
		end
	rescue Timeout::Error
		p "#{network} Engine call timed out after #{timeout[network]} seconds"
	end		
end