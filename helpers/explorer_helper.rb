module ExplorerHelper
	require __dir__+'/views_helper'
	include ViewsHelper
	require __dir__+'/date_helper'
	include DateHelper	
	require 'launchy'

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

	def number_of_cc_tx_in_month(opts={})
		month_offset = opts[:offset]
		debug = opts[:debug]
		network = opts[:network]
		# total number of cctx in a calendar month. Without offset its the current month. offset of 1, previous month, as so on.
		now_date = Date.parse(Time.now.to_s)
		date = (now_date << month_offset)	
		start_month_number = date.strftime("%m").to_i
		start_year = date.strftime("%Y")
		next_month_number = (start_month_number % 12) + 1
		next_month_year = start_month_number == 12 ? start_year.to_i + 1 : start_year
		this_month_time = Time.parse("1/#{start_month_number}/#{start_year}")
		next_month_time = Time.parse("1/#{next_month_number}/#{next_month_year}")
		end_time = next_month_time.to_i * 1000
		start_time = this_month_time.to_i * 1000
		bucket_ms = end_time - start_time
		
		query(start_time,end_time,bucket_ms,debug: debug, network: network)
	end

	def number_of_cc_tx_in_last_hours(hours=24)
		ms_in_hour = 1000 * 60 * 60
		duration_ms = ms_in_hour * hours.to_i
		end_time = Time.now.to_i*1000
		start_time = end_time - duration_ms
		group_by_number_of_hours = 1
		bucket_ms = ms_in_hour * group_by_number_of_hours
		
		query(start_time,end_time,bucket_ms,debug: debug, network: network)
	end

	def number_of_cc_tx_by_hour(hours = 0)
		# by defaults gives total number of CC tx in last hour. if you set hours gives hourly since hours ago
		now = Time.now
		now_hour_number = now.strftime("%H").to_i
		now_day = now.strftime("%d")
		raw_start_time = now - 3600 * hours
		start_hour_number = raw_start_time.strftime("%H").to_i
		start_day = raw_start_time.strftime("%d")
		next_hour_number = (now_hour_number % 24) + 1
		next_hour_day = now_hour_number == 24 ? now_day.to_i + 1 : now_day
		start_hour_time = Time.parse("#{start_day} #{start_hour_number}")
		end_hour_time = Time.parse("#{next_hour_day} #{next_hour_number}")
		end_time = end_hour_time.to_i * 1000
		start_time = start_hour_time.to_i * 1000
		bucket_ms = 1000*3600
		query(start_time,end_time,bucket_ms,debug: debug, network: network)
	end

	def number_of_cc_tx_by_dates(opts={})
		debug = opts[:debug]
		network = opts[:network]
		start_day = opts[:start_day]
		end_day = opts[:end_day]
		times = dates_are_numbers(start_day,end_day)
		# p Time.at(times[:from]/1000)
		# p Time.at(times[:till]/1000)
		# 24h buckets
		# offset = 1000*3600*2
		offset = 0
		bucket_miliseconds = 1000*3600*24
		query(times[:from]-offset,times[:till]-offset,bucket_miliseconds,debug: debug, network: network)
	end

	def number_of_cc_tx_by_days(opts={})
		debug = opts[:debug]
		network = opts[:network]
		num_days = opts[:num_days]
		times = days_are_numbers(num_days)
		# p Time.at(times[:from]/1000)
		# p Time.at(times[:till]/1000)
		# 24h buckets
		# offset = 1000*3600*2
		offset = 0
		bucket_miliseconds = 1000*3600*24
		query(times[:from]-offset,times[:till]-offset,bucket_miliseconds,debug: debug, network: network)
	end

	def total_number_of_cc_tx_by_days(opts={})
		limit = opts[:limit] || 0
		offset = opts[:offset] || 0
		network = opts[:network] || :mainnet
		debug = opts[:debug] || false
		return 0 if limit < 0
		times = days_are_numbers(limit,offset)
		# one bucket
		bucket_miliseconds = 1000*3600*24*(limit+1)*1000
		result = query(times[:from],times[:till],bucket_miliseconds,debug: debug, network: network)
		return result.first['txsSum']
	end

	def total_number_of_cc_tx_by_hours(opts={})
		limit = opts[:limit] || 0
		offset = opts[:offset] || 0
		network = opts[:network] || :mainnet
		debug = opts[:debug] || false
		return 0 if limit < 0
		times = hours_are_numbers({limit: limit,offset: offset})
		# one bucket
		bucket_miliseconds = (times[:till] - times[:from])*1000
		p "Querying for number of assets between #{Time.at(times[:from]/1000)} and #{Time.at(times[:till]/1000)} "
		result = query(times[:from],times[:till],bucket_miliseconds,debug: debug, network: network)
		return result.first['txsSum']
	end

	def get_cc_tx_last_days(opts={})
		limit = opts[:limit] || 0
		offset = opts[:offset] || 0		
		debug = opts[:debug] || false
		network = opts[:network] || :mainnet			
		init_time = Time.now
		num_of_tx = total_number_of_cc_tx_by_days(limit: limit, offset: offset, debug: debug, network: network)
		p "Total number of #{network.upcase} cc tx in this period: #{num_of_tx}" if debug
		num_tx_before = total_number_of_cc_tx_by_days(limit: offset-1, debug: debug, network: network)
		p "Total number of #{network.upcase} cc tx before this period: #{num_tx_before}" if debug
		result = []
		num_of_tx.times.each_slice(100).each_with_index do |s,i|
			endpoint = "getcctransactions?limit=#{s.last-s.first}&skip=#{num_tx_before+s.first}"
			query = explorer_api(network)+ endpoint
			init_time = Time.now
			p "Calling Explorer API with [#{query}]" 
			data = HTTParty.get(query)
			p "Explorer API replied within [#{time_diff(init_time)}]" 
			raw_data = data.parsed_response
			batch = raw_data.map{|tx| {
				# txid: tx['txid'],
				time: tx['blocktime'],
				# pretty_time: Time.at(tx['blocktime']/1000),
				type: tx['ccdata'].first['type'],
				asset_ids: tx['vout'].map{|x| x['assets']}.flatten.map{|e| e["assetId"] if e}.compact.uniq
				}}
			# File.write("#{__dir__}/../data/#{endpoint}.json",batch.to_json) if debug
			result << batch
		end
		result.flatten
	end

	def get_cc_tx_last_hours(opts={})
		limit = opts[:limit] || 24
		offset = opts[:offset] || 0		
		debug = opts[:debug] || false
		network = opts[:network] || :mainnet			
		init_time = Time.now
		num_of_tx = total_number_of_cc_tx_by_hours(limit: limit, offset: offset, debug: debug, network: network)
		p "Total number of #{network.upcase} cc tx in this period: #{num_of_tx}" if debug
		num_tx_before = total_number_of_cc_tx_by_hours(limit: offset-1, debug: debug, network: network)
		p "Total number of #{network.upcase} cc tx before this period: #{num_tx_before}" if debug
		result = []
		num_of_tx.times.each_slice(100).each_with_index do |s,i|
			endpoint = "getcctransactions?limit=#{s.last-s.first}&skip=#{num_tx_before+s.first}"
			query = explorer_api(network)+ endpoint
			init_time = Time.now
			p "Calling Explorer API with [#{query}]" 
			data = HTTParty.get(query)
			p "Explorer API replied within [#{time_diff(init_time)}]" 
			raw_data = data.parsed_response
			batch = raw_data.map{|tx| {
				# txid: tx['txid'],
				time: tx['blocktime'],
				# pretty_time: Time.at(tx['blocktime']/1000),
				type: tx['ccdata'].first['type'],
				asset_ids: tx['vout'].map{|x| x['assets']}.flatten.map{|e| e["assetId"] if e}.compact.uniq
				}}
			# File.write("#{__dir__}/../data/#{endpoint}.json",batch.to_json) if debug
			result << batch
		end
		result.flatten
	end

	def query(start_time,end_time,bucket_ms,opts={})
		debug = opts[:debug] || false
		network = opts[:network] || :mainnet	
		init_time = Time.now
		query = explorer_api(network)+"gettransactionsbyintervals?start=#{start_time}&end=#{end_time}&interval=#{bucket_ms}"		
		p "start_time: #{start_time} [#{Time.at(start_time/1000)}], end_time: #{end_time} [#{Time.at(end_time/1000)}]" if debug
		p "Calling Explorer API with [#{query}]" 
		data = HTTParty.get(query)
		p "Explorer API replied within [#{time_diff(init_time)}]"
		raw_data =  data.parsed_response		
	end	

	def get_asset_metadata(asset_id,opts={})
		debug = opts[:debug] || true
		network = opts[:network] || :mainnet			
		issuances = query_explorer_api("getassetinfowithtransactions?assetId=#{asset_id}",debug: debug, network: network)['issuances'].first		
		return unless issuances
		txid = issuances['txid']
		vout = issuances['vout'].select do |vout|
			!vout['assets'].empty? 
			# vout['assets'].first['assetId'] == asset_id
		end.first
		index = vout['n']
		asset_metadata = query_cc_api("assetmetadata/#{asset_id}/#{txid}%3A#{index}",network: network, debug: debug)
		return unless asset_metadata
		metadata = asset_metadata['metadataOfIssuence']['data'] if asset_metadata['metadataOfIssuence'] && asset_metadata['metadataOfIssuence']['data'] 
		return metadata
	end

	def query_explorer_api(endpoint, opts={})
		debug = opts[:debug] || false
		network = opts[:network] || :mainnet
		init_time = Time.now
		query = explorer_api(network.to_sym) + endpoint		
		p "Calling Explorer API with [#{query}]"
		data = HTTParty.get(query)
		p "Explorer API replied within [#{time_diff(init_time)}]"
		data.parsed_response			
	end

	def query_cc_api(endpoint, opts={})
		debug = opts[:debug] || false
		network = opts[:network] || :mainnet		
		init_time = Time.now
		query = cc_api(network) + endpoint		
		p "Calling CC API with [#{query}]"
		data = HTTParty.get(query)
		p "CC API replied within [#{time_diff(init_time)}]"
		data.parsed_response			
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

	def explorer_link_to_asset(asset_id,network)
		case network
		when :mainnet
			"http://coloredcoins.org/explorer/asset/#{asset_id}"
		when :testnet
			"http://coloredcoins.org/explorer/testnet/asset/#{asset_id}"
		else
			puts "[#{network}] is not a recognized bitcoin network, using mainnet instead"
			"http://coloredcoins.org/explorer/asset/#{dp[:asset_id]}"
		end		
	end

end

