module NewrelicHelper
	require __dir__+'/views_helper'
	include ViewsHelper	

	NEWRELIC_BASE = 'https://api.newrelic.com/v2/mobile_applications'
	NEWRELIC_HEADER = { "X-Api-Key"=> APP_CONFIG['newrelic_api_key'] }

	def newrelic_mobile_active_users
		newrelic_url = NEWRELIC_BASE + '.json'		
		response = HTTParty.get(newrelic_url,headers: NEWRELIC_HEADER).parsed_response			
	end

	def newrelic_mobile_data(app_id,metric,opts={})
		from = opts[:from] || datestamp(-1)
		to = opts[:to] || datestamp
		period = opts[:period] || (Time.parse(to) - Time.parse(from))
		newrelic_url = NEWRELIC_BASE
		newrelic_url += "/#{app_id}/metrics/data.json"
		newrelic_url += "?names[]=#{metric}"
		newrelic_url += "&from=#{from}" if from
		newrelic_url += "&to=#{to}" if to
		newrelic_url += "&period=#{period}" if period
		response = HTTParty.get(newrelic_url,headers: NEWRELIC_HEADER).parsed_response
	end
 

end

=begin
https://api.newrelic.com/v2/mobile_applications/13281912/metrics/data.json?names[]=Custom/androidCategory/send+to+address&from=2016-01-27&to=2016-01-28&period=86400
=end