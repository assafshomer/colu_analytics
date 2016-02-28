require __dir__+'/../../setup'

require __dir__+'/../../helpers/engine_helper'
include EngineHelper

streams = {mainnet: '759f20c696',testnet: 'foo'}
timeout = {mainnet: 30, testnet: 30}
debug = false

[:mainnet, :testnet].each do |network|
	next if network != :mainnet
	print_box("Processing #{network}")
	result = []
	begin
	  Timeout::timeout(timeout[network]) do
			result = bar_finance_stats
			print_box(result,'result') if debug
		end
	rescue Timeout::Error
		p "#{network} Engine call timed out after #{imeout[network]} seconds"
	end
	stream = streams[network]
	UPDATE.clear(stream)
	UPDATE.push_line(stream,result)			
end