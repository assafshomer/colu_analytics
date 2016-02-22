module ApiHelper
	require __dir__+'/views_helper'
	include ViewsHelper
	require __dir__+'/date_helper'
	include DateHelper	
	require 'launchy'

	def query_api(url, opts={})
		debug = opts[:debug] || false
		network = opts[:network] || :mainnet
		init_time = Time.now
		query = url
		p "Calling API with [#{query}]"
		data = HTTParty.get(query)
		p "API replied within [#{time_diff(init_time)}]"
		data.parsed_response			
	end

end

