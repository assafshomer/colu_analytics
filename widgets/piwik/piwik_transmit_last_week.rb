require __dir__+'/../../setup'

require __dir__+'/../../helpers/piwik_helper'
include PiwikHelper

stream = {mainent: 'AESSls3U', testnet: '479cf0445d'}
id_site = {mainnet: 7, testnet: 6}
timeout = {mainnet: 120, testnet: 180}
number_of_days = 7

[:mainnet, :testnet].each do |network|
	# next if network == :mainnet
	print_box("Processing #{network}")
	begin
	  Timeout::timeout(timeout[network]) do

			result = []
			number_of_days.times do |n|	
				curdate = Time.at(Time.now.to_i - 3600*24*n)
				method = "Actions.getPageUrls"
				segment = "pageTitle%3D%3Dengine.transmit_financed"	
				raw = piwik_data_during_day(curdate,segment: segment, method: method,id_site: id_site[network], debug: false)
				result << count_hits(raw,curdate)
			end			
			UPDATE.clear(stream[network])
			UPDATE.push_line(stream[network],result)
		end
	end
end