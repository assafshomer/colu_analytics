require __dir__+'/../../setup'

require __dir__+'/../../helpers/piwik_helper'
include PiwikHelper

stream = 'ahlfnage'
number_of_days = 7

result = []

number_of_days.times do |n|	
	curdate = Time.at(Time.now.to_i - 3600*24*n)
	method = "Actions.getPageUrls"
	segment = "pageTitle%3D%3D%2520engine.build_finance_send"
	raw = piwik_data_during_day(curdate,segment: segment, method: method, debug: false)
	result << count_hits(raw,curdate)
end

# UPDATE.clear(stream)
UPDATE.push_line(stream,result)
