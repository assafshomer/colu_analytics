require __dir__+'/../../setup'

require __dir__+'/../../helpers/piwik_helper'
include PiwikHelper

# stream = 'IJ5qcBMI'

curdate = Time.at(Time.now.to_i)
# curdate = Time.parse('2016-01-25')
number_of_results = 9999
method = "Live.getLastVisitsDetails"
raw = piwik_data_during_day(curdate, method: method, debug: false,limit: number_of_results)

visits = JSON.parse(raw)

general_data = visits.map do |visit|
	actions = parse_actions(visit)
	next if actions.empty?
	asset_id = percolate_asset_id(parse_actions(visit))
	user = percolate_user(parse_actions(visit))
	result = 
	{
		id: visit["idVisit"],
		ip: visit["visitIp"],
		country: visit["country"],
		city: visit["city"],
		flag: visit["countryFlag"],		
	}
	result[:actions] = actions unless (asset_id || user)
	result[:asset_id] = asset_id if asset_id
	result[:user] = user if user
	result
end.compact

general_data.each do |dp|
	puts "\n"
	p dp
end

