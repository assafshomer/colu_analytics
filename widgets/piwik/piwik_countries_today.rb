require __dir__+'/../../setup'

require __dir__+'/../../helpers/piwik_helper'
include PiwikHelper

stream = 'IJ5qcBMI'
debug = false
timeout = 30

curdate = Time.at(Time.now.to_i)
method = "UserCountry.getCountry"

begin
  Timeout::timeout(timeout) do
		raw=piwik_data_during_day(curdate,method:method,debug: debug)
		result = extract_country_data(raw)
		point = {"leaderboard": result}
		UPDATE.clear(stream)
		UPDATE.push_line(stream,point)		
  end
rescue Timeout::Error
	p "#{filename(__FILE__).upcase} (#{network.upcase}) timed out after #{timeout} seconds"
end	