
require __dir__+'/api_helper'
include ApiHelper
require 'active_support/core_ext/integer/inflections'
module EngineHelper
	def multiline_finance_stats()
		total = []
		average = []
		period = 'hour'
		data = query_engine_api('get_engine_stats',params: "&interval=#{period}")
		relevant = data.each do |dp|
			date = dp["_id"]
			h,d,m,y = date["hour"].to_s,date["day"],date["month"],date["year"]
			time = Time.parse("#{d}/#{m}/#{y} #{h}").to_i
			tot = (dp["total_fee"]+dp["total_value"]).round
			avg = (dp["average_fee"]+dp["average_value"]).round
			total << prepare_point(mbtc(tot),time)
			average << prepare_point(mbtc(avg),time)			
		end
		{total: total, average: average}
	end

	def finance_stats_bar(number_of_days)
		total = []
		average = []	
		period = 'day'
		data = query_engine_api('get_engine_stats',params: "&interval=#{period}")
		relevant = data.each do |dp|
			date = dp["_id"]
			h,d,m,y = date["hour"].to_s,date["day"],date["month"],date["year"]
			timestamp = Time.parse("#{d}/#{m}/#{y} #{h}")
			time = timestamp.strftime("#{Time.at(timestamp).day.ordinalize}")
			tot = (dp["total_fee"]+dp["total_value"]).round
			avg = (dp["average_fee"]+dp["average_value"]).round
			total << {name: time, value: mbtc(tot), color: 'green',timestamp: timestamp }
			average << prepare_point(mbtc(avg.to_f).round(2),timestamp.to_i)
		end
		bar_chart = total.sort_by{|e| e[:timestamp]}.last(number_of_days)
		{total: {chart: bar_chart}, average: average}
	end
	def prepare_point(number,timestamp)
		h={"number" => number, "timestamp" => timestamp}
		JSON.parse(h.to_json)
	end


	def prepare_multibar_point(number,timestamp)
		h={"number" => number, "timestamp" => timestamp}	
		JSON.parse(h.to_json)
	end

	def mbtc(satoshis)
		(satoshis/100000)
	end

end




=begin
GET: get_engine_stats
params:
token: a session token of an admin user
interval: group together by, values: ['hour', 'day', 'month', 'year', NONE], no value: group together all transaction
start: from where to start: values: ISO string, no value: beginning of all time
end: till when: values: ISO string, no value: now
purpose: what kind of transaction: values: ['issue', 'send', 'all', NONE], all value will group send and issue indevedualy, no value will group them together
=end