require __dir__+'/../../setup'

require __dir__+'/../../helpers/piwik_helper'
include PiwikHelper

stream = 'IJ5qcBMI'

result = nil

curdate = Time.at(Time.now.to_i)
method = "UserCountry.getCountry"

timeout = timeout

begin
  Timeout::timeout(timeout) do

		raw = piwik_data_during_day(curdate, method: method, debug: true)
		result = extract_country_data(raw)

		point = {"leaderboard": result}

		UPDATE.clear(stream)
		UPDATE.push_line(stream,point)
		
  end
rescue Timeout::Error
	p "Explorer call timed out after #{timeout} seconds"
end	