require __dir__+'/../../setup'

require __dir__+'/../../helpers/piwik_helper'
include PiwikHelper

stream = 'QzlPda2m'
number_of_days = 7

result = []

number_of_days.times do |n|	
	curdate = Time.at(Time.now.to_i - 3600*24*n)
	method = "Actions.getPageUrls"
	segment = "pageUrl%3D%40build_finance"	
	raw = piwik_data_during_day(curdate,segment: segment, method: method, debug: false)
	result << count_hits(raw,curdate)
end

# UPDATE.clear(stream)
UPDATE.push_line(stream,result)