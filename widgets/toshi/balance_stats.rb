require __dir__+'/../../setup'

streams = {mainnet: 'rByg08Tv', testnet: 'eefc149161'}
timeout = 30

[:mainnet, :testnet].each do |network|
	# next if network == :mainnet
	print_box "Processing #{network}"	
	begin
	  Timeout::timeout(timeout) do
	  	url = toshi_api(network)+'addresses/'+APP_CONFIG["#{network}_prod_address"]
			balance = HTTParty.get(url).parsed_response['balance']
			balance_pretty = (balance.to_f/100000000).round(3)
			stream = streams[network]
			UPDATE.clear(stream)
			UPDATE.push_line(stream,balance_pretty)  		
	  end
	rescue Timeout::Error
		p "#{filename(__FILE__).upcase} (#{network.upcase}) timed out after #{timeout} seconds"
	end		
end