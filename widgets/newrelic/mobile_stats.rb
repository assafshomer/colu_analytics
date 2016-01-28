require __dir__+'/../../setup'
require __dir__+'/../../helpers/newrelic_helper'
include NewrelicHelper
include ViewsHelper

stream = '3UN8UsIx'

stat_data = newrelic_mobile_active_users['applications']
p "stat_data #{stat_data}"

android_id = APP_CONFIG['newrelic_android_app_id']
ios_id = APP_CONFIG['newrelic_ios_app_id']

android_active_users = stat_data.select do |type|
	type["id"] == android_id
end.first['mobile_summary']['active_users']

ios_active_users = stat_data.select do |type|
	type["id"] == ios_id
end.first['mobile_summary']['active_users']

android_prefix = 'Custom/androidCategory/'
ios_prefix = 'Custom/completeSendProcessProfiling/'

params = 	
	{ios: [
		'sentByAddress[seconds]','sentByPhone[seconds]','signProcess[seconds]'
		], 
	android: [
		'send to address','send to phone','sign trans.','sync contacts'
	]}

newrelic_mobile_data(android_id,android_prefix+'send+to+address')

UPDATE.clear(stream)

metrics = ["Address", "Phone","Sign","Sync"]

titles = ["Send2A", "Send2P","Sign","Sync Contacts"]

header_row = ["Type", "# Users"] + titles
android = ["Android", android_active_users]
ios = ["iOS", ios_active_users]

metrics.each do |metric|
	android_metric_name = params[:android].select{|m| m =~ /#{metric}/i}.first
	if android_metric_name
		android_metric_avg_value = newrelic_mobile_data(android_id,android_prefix+android_metric_name)['metric_data']['metrics'].first['timeslices'].first['values']['average_value']
		p "#{android_metric_name}: #{android_metric_avg_value}"
		android << android_metric_avg_value.round(1).to_s+' sec'
	else
		android << '--'
	end

	ios_metric_name = params[:ios].select{|m| m =~ /#{metric}/i}.first
	if ios_metric_name
		ios_metric_avg_value = newrelic_mobile_data(ios_id,ios_prefix+ios_metric_name)['metric_data']['metrics'].first['timeslices'].first['values']['average_value'].round(1).to_s+' sec'
		p "#{ios_metric_name}: #{ios_metric_avg_value}"
		ios << ios_metric_avg_value			
	else
		ios << '--'
	end

end

table_rows = [android,ios]

p table_rows

UPDATE.push_table stream, header_row, table_rows


