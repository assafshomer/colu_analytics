module NewrelicHelper
	require __dir__+'/views_helper'
	include ViewsHelper	

	NEWRELIC_BASE = 'https://api.newrelic.com/v2/mobile_applications'
	NEWRELIC_HEADER = { "X-Api-Key"=> APP_CONFIG['newrelic_api_key'] }

	def newrelic_mobile_active_users(opts={})
		debug = opts[:debug] || false
		newrelic_url = NEWRELIC_BASE + '.json'
		call_newrelic_api(newrelic_url,debug)
	end

	def newrelic_mobile_data(app_id,metric,opts={})
		from = opts[:from] || datestamp
		to = opts[:to] || datestamp(+1)
		period = opts[:period] || (Time.parse(to) - Time.parse(from))
		debug = opts[:debug] || false
		newrelic_url = NEWRELIC_BASE
		newrelic_url += "/#{app_id}/metrics/data.json"
		newrelic_url += "?names[]=#{metric}"
		newrelic_url += "&from=#{from}" if from
		newrelic_url += "&to=#{to}" if to
		newrelic_url += "&period=#{period}" if period
		call_newrelic_api(newrelic_url,debug)
	end

	def call_newrelic_api(url,debug=false)
		init_time = Time.now
		p "Calling Newrelic API with [#{url}]" if debug
		data = HTTParty.get(url,headers: NEWRELIC_HEADER)
		p "Explorer API replied [#{time_diff(init_time)}]" if debug
		response = data.parsed_response
		p "newrelic response: #{response}" if debug
		return response
	end
 

end

=begin
https://api.newrelic.com/v2/mobile_applications/13281912/metrics/data.json?names[]=Custom/androidCategory/send+to+address&from=2016-01-27&to=2016-01-28&period=86400
=end