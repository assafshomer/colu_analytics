require __dir__+'/../../setup'

require __dir__+'/../../helpers/piwik_helper'
include PiwikHelper

stream = 'IJ5qcBMI'
number_of_days = 1

result = nil

number_of_days.times do |n|	
	curdate = Time.at(Time.now.to_i - 3600*24*n)
	method = "UserCountry.getCountry"
	raw = piwik_data_during_day(curdate, method: method, debug: false)
	result = extract_country_data(raw)
end

point = {"leaderboard": result}

UPDATE.clear(stream)
UPDATE.push_line(stream,point)
