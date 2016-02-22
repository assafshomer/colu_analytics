require __dir__+'/../../setup'

require __dir__+'/../../helpers/piwik_helper'
include PiwikHelper

stream = 'deyodFog'
number_of_days = 7

result = []

number_of_days.times do |n|	
	curdate = Time.at(Time.now.to_i - 3600*24*n)
	method = "Actions.getPageUrls"
	segment = "pageUrl%3D%3Dhttps%253A%252F%252Fapi.coloredcoins.org%252Fv3%252Fissue,pageUrl%3D%3Dhttps%253A%252F%252Fapi.coloredcoins.org%252Fv3%252Fsendasset"
	id_site = 16
	raw = piwik_data_during_day(curdate,segment: segment, method: method,id_site: id_site, debug: false)
	p raw
	result << count_hits(raw,curdate)
end

UPDATE.clear(stream)
UPDATE.push_line(stream,result)