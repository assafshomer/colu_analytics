require __dir__+'/../../setup'

require __dir__+'/../../helpers/piwik_helper'
include PiwikHelper

stream = 'IJ5qcBMI'

result = nil

curdate = Time.at(Time.now.to_i)
p curdate
method = "UserCountry.getCountry"
raw = piwik_data_during_day(curdate, method: method, debug: true)
result = extract_country_data(raw)

point = {"leaderboard": result}

UPDATE.clear(stream)
UPDATE.push_line(stream,point)
