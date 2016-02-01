require __dir__+'/../../setup'

require __dir__+'/../../helpers/piwik_helper'
include PiwikHelper

# stream = 'IJ5qcBMI'

curdate = Time.at(Time.now.to_i)
curdate = Time.parse('2016-01-25')
number_of_results = 10
method = "Live.getLastVisitsDetails"
raw = piwik_data_during_day(curdate, method: method, debug: false,limit: number_of_results)

visits = JSON.parse(raw)

general_data = visits.map do |visit|
	{
		ip: visit["visitIp"],
		country: visit["country"],
		city: visit["city"],
		flag: visit["countryFlag"]		
	}
end

black_list = %w(engine.is_addresses_active engine.is_running user_managment.register_user mobile_server.sync_contact_deltas mobile_server.verify_sync_contacts mobile_server_new.upsert_wallets colusite.index)
white_list = %w(url timeSpentPretty pageTitle)
# p general_data

actions = visits.map do |visit|
	action_details = visit["actionDetails"]
	interesting_actions = action_details.reject do |action_detail|
		action_detail["type"] != "action" || 
		black_list.include?(action_detail["pageTitle"])
	end
	interesting_actions.map{|a| a.select{|k,v| white_list.include?(k)}}
end.flatten

# p actions

concise_calls = actions.map do |x|
	tmp = x["url"].gsub('?','&').split('&')
	tmp.shift
	tmp << "call=#{x['pageTitle']}"
	tmp.reject{|e| e =~ /numConfirmations/}
end.uniq

# p concise_calls

result = concise_calls.map do |call|
	call.map do |detail|
		[detail.split('=')].to_h
	end
end.flatten.uniq

p result