require __dir__+'/../../setup'

require __dir__+'/../../helpers/piwik_helper'
include PiwikHelper

streams = {mainnet: 'nB1a42B9', testnet: '5yI6V0ZQ'}
id_site = {mainnet: 7, testnet: 6}
timeout = {mainnet: 120, testnet: 180}
number_of_days = 7

[:mainnet, :testnet].each do |network|
	# next if network == :mainnet
	print_box "Processing #{network}"
	begin
	  Timeout::timeout(timeout[network]) do

			result = []
			number_of_days.times do |n|	
				curdate = Time.at(Time.now.to_i - 3600*24*n)
				method = "Actions.getPageUrls"
				segment = "pageTitle%3D%3Dmobile_server.send_asset"
				raw = piwik_data_during_day(curdate,segment: segment, method: method,id_site: id_site[network],network: network, debug: false)
				result << count_hits(raw,curdate)
			end
			stream = streams[network]
			UPDATE.clear(stream)
			UPDATE.push_line(stream,result)
		end
	rescue Timeout::Error
		p "#{filename(__FILE__).upcase} (#{network.upcase}) timed out after #{timeout} seconds"
	end		
end