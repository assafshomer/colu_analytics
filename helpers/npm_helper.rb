
require __dir__+'/api_helper'
include ApiHelper
require __dir__+'/leftronic_helper'
include LeftronicHelper
require 'active_support/core_ext/integer/inflections'

module NpmHelper

	def downloads_in_month(opts={})
		month_offset = opts[:offset] || 0
		debug = opts[:debug] || false
		now_date = Date.parse(Time.now.to_s)
		date = (now_date << month_offset)	
		start_month_number = date.strftime("%m").to_i
		start_year = date.strftime("%Y")
		next_month_number = (start_month_number % 12) + 1
		next_month_year = start_month_number == 12 ? start_year.to_i + 1 : start_year
		period = "#{start_year}-#{pad(start_month_number)}-01:#{next_month_year}-#{pad(next_month_number)}-01"
		p period
		p query_npm_api(period)
	end
	def pad(month)
		month < 10 ? "0#{month}" : month.to_s
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