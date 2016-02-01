module PiwikHelper
	require __dir__+'/views_helper'
	include ViewsHelper

	PIWIK_FILTER_LIMIT = 9999

	PIWIK_BASE = "https://analytics.colu.co/?module=API&idSite=7&format=json&token_auth=#{APP_CONFIG['piwik_auth_token']}"

	def piwik_data_during_day(date,opts={debug: false})
		debug = opts[:debug]
		segment = opts[:segment]
		method = opts[:method]
		limit = opts[:limit] || PIWIK_FILTER_LIMIT
		single_day_setting = "&date=#{date.strftime("%Y-%m-%d")}&period=day"
		piwik_url = PIWIK_BASE
		piwik_url += single_day_setting
		piwik_url += "&segment=#{segment}" if segment
		piwik_url += "&method=#{method}" if method
		piwik_url += "&filter_limit=#{limit}" if limit
		call_piwik_api(piwik_url,debug: debug)
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

	def piwik_countries_during_day(date,segment,opts={debug: false})
		piwik_url = PIWIK_BASE + "&date=#{date.strftime("%Y-%m-%d")}&period=day&segment=#{segment}"
		response = HTTParty.get(piwik_url).parsed_response
		hits = response.map{|r| r['nb_hits']}.inject(:+)
		date_midnight = Time.parse(date.strftime("%Y-%m-%d")).to_i
		hash = {"number" => hits, "timestamp" => date_midnight}	
		JSON.parse(hash.to_json)				
	end

	def call_piwik_api(url,opts={})
		debug = opts[:debug] || false
		init_time = Time.now
		p "Calling Piwik API with [#{url}]" if debug
		data = HTTParty.get(url)
		p "Piwik API replied [#{time_diff(init_time)}]" if debug
		response = data.parsed_response
		p "Piwik response: #{response}" if debug
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
			action_detail["type"] != "action" || 
			black_list.include?(action_detail["pageTitle"])
		end
		data = interesting_actions.map do |action|
			action.select{|k,v| white_list.include?(k)}
		end
		nice_data = data.map do |x|
			tmp = x["url"].gsub('?','&').split('&')
			tmp.shift
			tmp << "call=#{x['pageTitle']}"
			tmp.reject{|e| e =~ /numConfirmations/}
		end.uniq
		result = nice_data.map do |call|
			call.map do |detail|
				[detail.split('=')].to_h
			end
		end.flatten.uniq		
		return result
	end

	def percolate_asset_id_from_array(parsed_actions)
		puts "\parsed_actions #{parsed_actions}\n"
		relevant_data = parsed_actions.reject{|d| d[:actions].nil? || d[:actions].empty?}
		puts "\nrelevant_data #{relevant_data}\n"
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

	def percolate_asset_id(data)		
		return if data.empty?		
		asset_data = data.select{|e| e.keys.include?("assetId")}
		return if asset_data.empty?
		return asset_data.first["assetId"]		
	end
	def percolate_user(data)		
		return if data.empty?		
		asset_data = data.select{|e| e.keys.include?("userName")}
		return if asset_data.empty?
		return asset_data.first["userName"]		
	end		

end

