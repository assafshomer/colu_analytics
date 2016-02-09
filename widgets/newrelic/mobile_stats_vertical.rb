require __dir__+'/../../setup'
require __dir__+'/../../helpers/newrelic_helper'
include NewrelicHelper
include ViewsHelper

stream = 'xLpTTCGk'
debug = true
number_of_days = 1

stat_data = newrelic_mobile_active_users(debug: false)['applications']
oss = [:android,:ios]

ids = oss.map{|os| [os.to_sym,APP_CONFIG["newrelic_#{os}_app_id"]]}.to_h

active_users = ids.map do |k,v|	
	tmp = stat_data.select do |d|		
		d["id"].to_i == v.to_i
	end	
	au = tmp.first['mobile_summary']['active_users'] 	
	[k,au]
end.to_h

android_prefix = 'Custom/androidCategory/'
ios_prefix = 'Custom/completeSendProcessProfiling/'
android_params = ['send to address','send to phone','sign trans.','sync contacts']
ios_params = ['sentByAddress[seconds]','sentByPhone[seconds]','signProcess[seconds]']

prefixes = oss.map{|os| [os.to_sym,eval("#{os}_prefix")]}.to_h
params = oss.map{|os| [os.to_sym,eval("#{os}_params")]}.to_h

metrics = ["Address", "Phone","Sync"]
titles = ["Send2A", "Send2P","Sync Contacts"]
header_row = ['Metric', "Android", "iOS"]

# rows = {ios:[], android: []}
rows_titles = ["Active Users", "Send 2 Address", "Send 2 Phone", "Sync Contacts"]
rows = rows_titles.map{|t| [t,[t]]}.to_h

rows["Active Users"] <<  oss.map{|os| active_users[os] }

oss.each_with_index do |os,i|
	metrics.each do |metric|
		metric_name = params[os].select{|m| m =~ /#{metric}/i}.first
		row_name = rows_titles.select{|rt| rt =~ /#{metric}/i}.first
		if metric_name			
			metric_raw_data = newrelic_mobile_data(ids[os],prefixes[os]+metric_name,{debug: false,to: datestamp(+1),from: datestamp(number_of_days-1)})
			if metric_raw_data.keys.first == 'error'
				p "#{os} | #{metric_name}: --" if debug
				rows[row_name][i+1] = '--'	
			else
				metric_values = metric_raw_data['metric_data']['metrics'].first['timeslices'].first['values']
				# p "metric_values #{metric_values}"
				metric_avg_value = metric_values['average_value']
				display = metric_avg_value.round(1).to_s+' sec'
				p "#{os} | #{metric_name}: #{display}" if debug
				rows[row_name][i+1] = display
			end
		else
			p "#{os} | #{metric_name}: --" if debug
			rows[row_name][i+1] = '--'	
		end
	end	
end

table_rows = rows_titles.map{|rt| rows[rt].flatten}

p header_row
p table_rows

# UPDATE.clear(stream)
UPDATE.push_table stream, header_row, table_rows