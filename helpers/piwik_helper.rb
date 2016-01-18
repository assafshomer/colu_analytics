module PiwikHelper
	require __dir__+'/views_helper'
	include ViewsHelper

	PIWIK_FILTER_LIMIT = 9999

	PIWIK_BASE = "https://analytics.colu.co/?module=API&method=Actions.getPageUrls&idSite=7&format=json&filter_limit=#{PIWIK_FILTER_LIMIT}&token_auth=#{APP_CONFIG['piwik_auth_token']}"

	def piwik_data_during_day(date,segment,opts={debug: false})
		piwik_url = PIWIK_BASE + "&date=#{date.strftime("%Y-%m-%d")}&period=day&segment=#{segment}"
		response = HTTParty.get(piwik_url).parsed_response
		hits = response.map{|r| r['nb_hits']}.inject(:+)
		date_midnight = Time.parse(date.strftime("%Y-%m-%d")).to_i
		hash = {"number" => hits, "timestamp" => date_midnight}	
		JSON.parse(hash.to_json)				
	end

end

