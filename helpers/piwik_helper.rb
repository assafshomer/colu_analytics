module PiwikHelper
	require __dir__+'/views_helper'
	include ViewsHelper

	PIWIK_FILTER_LIMIT = 9999

	PIWIK_BASE = "https://analytics.colu.co/?module=API&idSite=7&format=json&filter_limit=#{PIWIK_FILTER_LIMIT}&token_auth=#{APP_CONFIG['piwik_auth_token']}"

	def piwik_data_during_day(date,opts={debug: false})
		debug = opts[:debug]
		segment = opts[:segment]
		method = opts[:method]
		single_day_setting = "&date=#{date.strftime("%Y-%m-%d")}&period=day"
		piwik_url = PIWIK_BASE
		piwik_url += single_day_setting
		piwik_url += "&segment=#{segment}" if segment
		piwik_url += "&method=#{method}" if method
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
		p "Calling Pikiw API with [#{url}]" if debug
		data = HTTParty.get(url)
		p "Pikiw API replied [#{time_diff(init_time)}]" if debug
		response = data.parsed_response
		p "Pikiw response: #{response}" if debug
		return response
	end	

end

