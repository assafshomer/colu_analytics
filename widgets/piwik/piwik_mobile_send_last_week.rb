require __dir__+'/../../setup'

require __dir__+'/../../helpers/piwik_helper'
include PiwikHelper

stream = 'nB1a42B9'
number_of_days = 7

result = []

number_of_days.times do |n|	
	curdate = Time.at(Time.now.to_i - 3600*24*n)
	method = "Actions.getPageUrls"
	segment = "pageTitle%3D%3Dmobile_server.send_asset"
	raw = piwik_data_during_day(curdate,segment: segment, method: method, debug: false)
	result << count_hits(raw,curdate)
end

# UPDATE.clear(stream)
UPDATE.push_line(stream,result)
