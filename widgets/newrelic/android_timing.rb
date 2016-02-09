require __dir__+'/../../setup'
require __dir__+'/../../helpers/newrelic_helper'
include NewrelicHelper
include ViewsHelper

stream = 'xLpTTCGk'
debug = true
number_of_days = 7

stat_data = newrelic_mobile_active_users(debug: false)['applications']
oss = [:android]

ids = oss.map{|os| [os.to_sym,APP_CONFIG["newrelic_#{os}_app_id"]]}.to_h

android_prefix = 'Custom/androidCategory/'
ios_prefix = 'Custom/completeSendProcessProfiling/'
android_params = ['send to address','send to phone','sign trans.','sync contacts']
ios_params = ['sentByAddress[seconds]','sentByPhone[seconds]','signProcess[seconds]']

prefixes = oss.map{|os| [os.to_sym,eval("#{os}_prefix")]}.to_h
params = oss.map{|os| [os.to_sym,eval("#{os}_params")]}.to_h

metrics = ["Address", "Phone","Sync"]
titles = ["Send2A", "Send2P","Sync Contacts"]
header_row = ['Metric',"Avg","Min","Max","Size"]
columns = header_row.last(header_row.length-1)
rows_titles = ["Send 2 Address", "Send 2 Phone", "Sync Contacts"]
rows = rows_titles.map{|t| [t,[t]]}.to_h

oss.each do |os|
	metrics.each do |metric|
		metric_name = params[os].select{|m| m =~ /#{metric}/i}.first
		row_name = rows_titles.select{|rt| rt =~ /#{metric}/i}.first
		if metric_name			
			metric_raw_data = newrelic_mobile_data(ids[os],prefixes[os]+metric_name,{debug: false,to: datestamp(+1),from: datestamp(1-number_of_days)})
			if metric_raw_data.keys.first == 'error'
				p "#{os} | #{metric_name}: --" if debug
				columns.each_with_index do |c,i|
					rows[row_name][i+1] = '--'
				end				
			else
				metric_values = metric_raw_data['metric_data']['metrics'].first['timeslices'].first['values']
				cats = ['average_value','min_value','max_value','call_count']
				units = [' sec',' sec',' sec',nil]
				display = cats.each_with_index.map do |c,i|
					r = units[i].nil? ? 0 : 1
					[c.to_sym,metric_values[c].round(r).to_s+units[i].to_s]
				end.to_h
				cats.each_with_index do |category,i|
					rows[row_name][i+1] = display[category.to_sym]	
				end				
			end
		else
			p "#{os} | #{metric_name}: --" if debug
			columns.each_with_index do |c,i|
				rows[row_name][i+1] = '--'
			end	
		end
	end	
end

table_rows = rows_titles.map{|rt| rows[rt].flatten}

# p header_row
# p table_rows

# UPDATE.clear(stream)
UPDATE.push_table stream, header_row, table_rows