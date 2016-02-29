require __dir__+'/../../setup'

require __dir__+'/../../helpers/piwik_helper'
include PiwikHelper

streams = {mainnet: 'deyodFog', testnet: '7SU2lAWK'}
id_site = {mainnet: 16, testnet: 15}
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
				nw = (network==:testnet) ? 'testnet.' : ''
				method = "Actions.getPageUrls"
				segment = "pageUrl%3D%3Dhttps%253A%252F%252F#{nw}api.coloredcoins.org%252Fv3%252Fissue,pageUrl%3D%3Dhttps%253A%252F%252Fapi.coloredcoins.org%252Fv3%252Fsendasset"
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