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

	def query_explorer_api(endpoint, opts={})
		network = opts[:network] || :mainnet
		url = explorer_api(network.to_sym) + endpoint		
		query_api(url,opts)
	end

	def query_cc_api(endpoint, opts={})
		network = opts[:network] || :mainnet		
		url = cc_api(network) + endpoint		
		query_api(url,opts)
	end

	def query_engine_api(endpoint, opts={})
		network = opts[:network] || :mainnet
		params = opts[:params]
		endpoint+="?token=#{APP_CONFIG['mainnet_engine_admin_token']}"
		endpoint+=params if params
		url = engine_api(network) + endpoint		
		query_api(url,opts)
	end

	def query_jenkins_api(request,opts={})
		init_time = Time.now
		reply = JENKINS.api_get_request(request)		
		p "JENKINS API replied within [#{time_diff(init_time)}]"
		reply
	end

	def explorer_api(network)
		case network.to_sym
		when :mainnet
			APP_CONFIG['mainnet_explorer_api_url']
		when :testnet
			APP_CONFIG['testnet_explorer_api_url']
		else
			puts "[#{network}] is not a recognized bitcoin network, using mainnet #{APP_CONFIG['mainnet_explorer_api_url']} instead"
			APP_CONFIG['mainnet_explorer_api_url']
		end
	end

	def engine_api(network)
		case network.to_sym
		when :mainnet
			APP_CONFIG['mainnet_engine_api_url']
		when :testnet
			APP_CONFIG['testnet_engine_api_url']
		else
			puts "[#{network}] is not a recognized bitcoin network, using mainnet #{APP_CONFIG['mainnet_explorer_api_url']} instead"
			APP_CONFIG['mainnet_explorer_api_url']
		end
	end

	def cc_api(network)
		case network.to_sym
		when :mainnet
			APP_CONFIG['mainnet_cc_api_url']
		when :testnet
			APP_CONFIG['testnet_cc_api_url']
		else
			puts "[#{network}] is not a recognized bitcoin network, using mainnet #{APP_CONFIG['mainnet_cc_api_url']} instead"
			APP_CONFIG['mainnet_cc_api_url']
		end
	end
	def toshi_api(network)	
		case network.to_sym
		when :mainnet
			return 'https://bitcoin.toshi.io/api/v0/'
		else
			return 'https://testnet3.toshi.io/api/v0/'
		end	
	end	
end

