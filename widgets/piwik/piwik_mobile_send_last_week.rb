require __dir__+'/../../setup'

require __dir__+'/../../helpers/piwik_helper'
include PiwikHelper

stream = 'OsclSZCJ'
number_of_days = 7

result = []

number_of_days.times do |n|	
	curdate = Time.at(Time.now.to_i - 3600*24*n)
	method = "Actions.getPageUrls"
	segment = "pageTitle%3D%3Dmobile_server.send_asset"
	result << piwik_data_during_day(curdate,opts={segment: segment, method: method, debug: true})	
end


UPDATE.clear(stream)
UPDATE.push_line(stream,result)

=begin
"https://analytics.colu.co/?module=API&method=Actions.getPageUrls&idSite=7&date=today&period=week&format=json&filter_limit=10&token_auth=04ed96c9526091a248bc30f4dff36ed6&segment=pageTitle%3D%3Dengine.transmit_financed"
=end