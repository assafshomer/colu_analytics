module PiwikHelper
	require __dir__+'/views_helper'
	include ViewsHelper
	require __dir__+'/api_helper'
	include ApiHelper
	
	PIWIK_FILTER_LIMIT = 9999

	PIWIK_BASE = "https://analytics.colu.co/?module=API&format=json&token_auth=#{APP_CONFIG['piwik_auth_token']}"

	def piwik_data_during_day(date,opts={debug: false})
		debug = opts[:debug] || false
		network = opts[:network] || :mainnet
		idSite = get_id_site_from_network(network)	
		segment = opts[:segment]
		method = opts[:method]
		filter = opts[:filter] || PIWIK_FILTER_LIMIT
		single_day_setting = "&date=#{date.strftime("%Y-%m-%d")}&period=day"
		piwik_url = PIWIK_BASE
		piwik_url += "&idSite=#{idSite}"
		piwik_url += single_day_setting
		piwik_url += "&segment=#{segment}" if segment
		piwik_url += "&method=#{method}" if method
		piwik_url += "&filter_limit=#{filter}" if filter
		call_piwik_api(piwik_url,debug: debug)
	end

	def piwik_data_during_period(opts = {})
		piwik_url = generate_piwik_api_url(opts)
		debug = opts[:deubg]
		network = opts[:network]
		call_piwik_api(piwik_url,debug: debug,network: network)
	end

	def generate_piwik_api_url(opts={})
		num_days = opts[:num_days].to_i
		days_offset = opts[:days_offset].to_i		
		end_date = (Time.now - days_offset.day).strftime("%Y-%m-%d")
		start_date = (Time.now - (days_offset+num_days).day).strftime("%Y-%m-%d")
		# p "Fetching Piwik data between #{start_date} and #{end_date}"
		date_range = "&period=range&date=#{start_date},#{end_date}"
		debug = opts[:debug] || false
		network = opts[:network] || :mainnet
		idSite = get_id_site_from_network(network)
		segment = opts[:segment]
		method = opts[:method]
		params = opts[:params]
		filter = opts[:filter] || PIWIK_FILTER_LIMIT

		piwik_url = PIWIK_BASE
		piwik_url += "&idSite=#{idSite}"
		piwik_url += date_range
		piwik_url += params if params
		piwik_url += "&segment=#{segment}" if segment
		piwik_url += "&method=#{method}" if method
		piwik_url += "&filter_limit=#{filter}" if filter
	end	

	def get_id_site_from_network(network)
		case network
		when :mainnet
			7
		when :testnet
			6
		else
			puts "[#{network}] is not a recognized bitcoin network, using mainnet settings instead"
			7
		end		
	end

	def count_hits(piwik_response,date)
		hits = piwik_response.map{|r| r['nb_hits']}.inject(:+)
		date_midnight = Time.parse(date.strftime("%Y-%m-%d")).to_i
		hash = {"number" => hits, "timestamp" => date_midnight}	
		JSON.parse(hash.to_json)			
	end

	def extract_country_data(piwik_response)
		piwik_response.map do |cdata|
			{name: cdata["label"], value: cdata["nb_visits"]}
		end
	end

	def piwik_countries_during_day(date,segment,opts={})
		debug = opts[:debug] || false
		network = opts[:network] || :mainnet
		idSite = get_id_site_from_network(network)
		piwik_url = PIWIK_BASE + "&idSite=#{idSite}&date=#{date.strftime("%Y-%m-%d")}&period=day&segment=#{segment}"
		response = HTTParty.get(piwik_url).parsed_response
		hits = response.map{|r| r['nb_hits']}.inject(:+)
		date_midnight = Time.parse(date.strftime("%Y-%m-%d")).to_i
		hash = {"number" => hits, "timestamp" => date_midnight}	
		JSON.parse(hash.to_json)				
	end

	def call_piwik_api(url,opts={})
		debug = opts[:debug] || true
		init_time = Time.now
		p "Calling Piwik API with [#{url}]" if debug
		data = HTTParty.get(url)
		p "Piwik API replied [#{time_diff(init_time)}]" if debug
		response = data.parsed_response
		# p "Piwik response: #{response}" if debug
		return response
	end

	def parse_actions(visit)
		black_list = %w(
			engine.is_addresses_active
			engine.is_running
			engine.get_addresses_utxos
			engine.get_addresses_info
			user_managment.register_user
			user_managment.update_user
			user_managment.verify_user
			user_managment.get_user
			mobile_server.sync_contact_deltas
			mobile_server.verify_sync_contacts
			mobile_server_new.upsert_wallets
			mobile_server_new.upgrade_mobile_user
			mobile_server_new.register_phone_number
			mobile_server_new.verify_phone_number
			colusite.index
			)
		white_list = %w(
			url 
			timeSpentPretty 
			pageTitle
			)
		action_details = visit["actionDetails"]
		interesting_actions = action_details.reject do |action_detail|
			# action_detail["type"] != "action" || 
			black_list.include?(action_detail["pageTitle"])
		end
		data = interesting_actions.map do |action|
			action.select{|k,v| white_list.include?(k)}
		end
		nice_data = data.map do |x|
			tmp = x["url"].gsub('?','&').split('&')
			tmp.shift
			tmp << "call=#{x['pageTitle']}" if x['pageTitle']
			tmp.reject{|e| e =~ /numConfirmations/}
		end.uniq
		result = nice_data.map do |call|
			call.map do |detail|
				# p "detail: #{detail}"
				[detail.split('=')].to_h
			end
		end.flatten.uniq		
		return result
	end

	def percolate_asset_id_from_array(parsed_actions)
		puts "\n parsed_actions #{parsed_actions}\n"
		relevant_data = parsed_actions.reject{|d| d[:actions].nil? || d[:actions].empty?}
		puts "\n relevant_data #{relevant_data}\n"
		asset_data = relevant_data.select do |visit|
			visit[:actions].map do |action|
				action.keys.include?("assetId")
			end.any?
		end
		extract_assetid = asset_data.map do |ad|
			ad.map do |k,v|
				# p "k: #{k}, v: #{v}"
				if k == :actions
					[:asset_id,v.select{|e| e.keys.include?('assetId')}.first['assetId']]
				else
					[k,v]
				end
			end.to_h
		end		
	end

	def percolate_asset_ids(data)		
		return if data.empty?		
		asset_data = data.select{|e| e.keys.include?("assetId")}
		return if asset_data.empty?
		return asset_data.map{|ad| ad["assetId"]}.uniq
	end
	def percolate_user(data)		
		return if data.empty?		
		asset_data = data.select{|e| e.keys.include?("userName")}
		return if asset_data.empty?
		return asset_data.first["userName"]		
	end
	def parse_visits(visits)
		visits.each_with_index.map do |visit,n|
			actions = parse_actions(visit)
			next if actions.empty? 
			asset_ids = percolate_asset_ids(actions)
			next unless asset_ids
			user = percolate_user(actions)
			result = []
			asset_ids.each do |asset_id|
				result_for_asset_id = 
				{
					piwik_id: visit["idVisit"],
					piwik_visitor: visit["visitorId"],
					ip: visit["visitIp"],
					country: visit["country"],
					city: visit["city"],
					flag: visit["countryFlag"],
					timestamp: visit["serverTimestamp"]
				}
				result_for_asset_id[:actions] = actions unless (asset_id || user)
				result_for_asset_id[:asset_id] = asset_id if asset_id
				result_for_asset_id[:user] = user if user
				# p "result: #{result}"
				result << result_for_asset_id				
			end
			result
		end.compact.flatten.uniq.compact
	end

	def pick_piwik_data_for_asset_id(asset_data,asset_id)
		return unless asset_data 
		asset_data.select{|visit| visit.keys.include?(:asset_id) && visit[:asset_id].to_s == asset_id.to_s }
	end

	def pick_piwik_data_by_key(asset_data,key_value_pair={})
		return unless asset_data && !key_value_pair.empty?
		k = key_value_pair.keys.first.to_sym
		v = key_value_pair[k]
		asset_data.select{|visit| visit.keys.include?(k) && visit[k].to_s == v.to_s }
	end	

	def piwik_link_to_user_profile(visitorId,opts={})
		network = opts[:network] || :mainnet
		method = 'Live.getVisitorProfile'
		generate_piwik_api_url(method: method,params: "&visitorId=#{visitorId}", network: network)
	end

	def get_user_data(visitor_id)
		return unless visitor_id
		method = "Live.getVisitorProfile"		
		url = generate_piwik_api_url(
			method: method, 
			debug: false,
			filter: 10,
			num_days: 2,
			days_offset: 0,
			network: :mainnet,
			params: "&visitorId=#{visitor_id}"
			)
			action_details = call_piwik_api(url)['lastVisits'].map do |visit|
				visit['actionDetails'] if visit['actionDetails']
			end.flatten
			return if action_details.blank?
			# print_box(action_details,'actionDetails')
			get_user = action_details.select do |a| 
				a['pageTitle']=="user_managment.get_user"
			end
			return if get_user.blank?
			# print_box(get_user,'get_user')
			user_link = get_user.map{|ud| ud['url']}.uniq
			return if user_link.blank?
			# print_box(user_link,'user_link')
			data = query_api(user_link.first)
			return data.select{|k,v| k =~ /^user/ && k !~ /key|seed|asset/ }
	end

end

=begin

{"user_phone"=>"", "user_company"=>"CARDIWEB", "user_email"=>"awalter@cardiweb.com", "user_name"=>"awalter@cardiweb.com", "user_full_name"=>"", "user_extended_key"=>"xpub6CGKKDJuUSojK87egjA3BDs2p89Zj4sFu2r5b2QLHaHpgnQGoRPhcPVudYwgPTUnfMGiL6V38PE3rKFvDGJvcmpAdzQsaPxQUhh7aePGrTU", "user_encrypted_seed"=>"6PYKX7eWEGYpVU41tWeM494gaJ3kFvaz54poo5CCKkHQW1FaehoNiETgtR", "user_asset_templates"=>[]}

this is a link to a specific visitor id
https://analytics.colu.co/index.php?module=API&method=Live.getVisitorProfile&format=JSON&idSite=7&visitorId=a326f7ed4a73c0f1&token_auth=04ed96c9526091a248bc30f4dff36ed6	

https://analytics.colu.co/index.php?module=CoreHome&action=index&idSite=7&period=day&date=today&segment=visitorId%3D%3Da326f7ed4a73c0f1#?module=Live&action=indexVisitorLog&idSite=7&period=day&date=today&visitorId=123&segment=visitorId%3D%3Da326f7ed4a73c0f1

https://analytics.colu.co/index.php?module=CoreHome&action=index&idSite=7&period=year&date=2016-02-04&segment=visitorId%3D%3Da326f7ed4a73c0f1#?module=Live&action=indexVisitorLog&idSite=7&segment=visitorId%3D%3Da326f7ed4a73c0f1&period=year&date=2016-02-04

https://analytics.colu.co/index.php?module=CoreHome&action=index&idSite=7&period=year&date=2016-02-04&segment=visitorId%3D%3Da326f7ed4a73c0f1#?module=Live&action=indexVisitorLog&idSite=7&segment=visitorId%3D%3Da326f7ed4a73c0f1&period=year&date=2016-02-04

=end

