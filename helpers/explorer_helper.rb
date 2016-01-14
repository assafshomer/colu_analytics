module ExplorerHelper

	def number_of_cc_tx_in_month(month_offset=0)
		# total number of cctx in a calendar month. Without offset its the current month. offset of 1, previous month, as so on.
		now_date = Date.parse(Time.now.to_s)
		date = (now_date << month_offset)	
		start_month_number = date.strftime("%m").to_i
		start_year = date.strftime("%Y")
		next_month_number = (start_month_number % 12) + 1
		next_month_year = start_month_number == 12 ? start_year.to_i + 1 : start_year
		this_month_time = Time.parse("1/#{start_month_number}/#{start_year}")
		next_month_time = Time.parse("1/#{next_month_number}/#{next_month_year}")
		end_time = next_month_time.to_i * 1000
		start_time = this_month_time.to_i * 1000
		bucket_ms = end_time - start_time
		
		data = HTTParty.get(EXPLORER_API+ "gettransactionsbyintervals?start=#{start_time}&end=#{end_time}&interval=#{bucket_ms}")

		raw_data =  data.parsed_response
	end

	def number_of_cc_tx_in_last_hours(hours=24)
		ms_in_hour = 1000 * 60 * 60
		duration_ms = ms_in_hour * hours.to_i
		end_time = Time.now.to_i*1000
		start_time = end_time - duration_ms
		group_by_number_of_hours = 1
		bucket_ms = ms_in_hour * group_by_number_of_hours
		
		data = HTTParty.get(EXPLORER_API+ "gettransactionsbyintervals?start=#{start_time}&end=#{end_time}&interval=#{bucket_ms}")

		raw_data =  data.parsed_response
	end

	def number_of_cc_tx_by_hour(hours = 0)
		# by defaults gives total number of CC tx in last hour. if you set hours gives hourly since hours ago
		now = Time.now

		now_hour_number = now.strftime("%H").to_i
		# p "now_hour_number #{now_hour_number}"
		now_day = now.strftime("%d")
		# p "now_day #{now_day}"

		raw_start_time = now - 3600 * hours
		# p "raw_start_time #{raw_start_time}"		
		
		start_hour_number = raw_start_time.strftime("%H").to_i
		# p "start_hour_number #{start_hour_number}"
		start_day = raw_start_time.strftime("%d")
		# p "start_day #{start_day}"

		next_hour_number = (now_hour_number % 24) + 1
		# p "next_hour_number #{next_hour_number}"
		next_hour_day = now_hour_number == 24 ? now_day.to_i + 1 : now_day
		# p "next_hour_day #{next_hour_day}"
		
		start_hour_time = Time.parse("#{start_day} #{start_hour_number}")
		# p "start_hour_time #{start_hour_time}"
		end_hour_time = Time.parse("#{next_hour_day} #{next_hour_number}")
		# p "end_hour_time #{end_hour_time}"

		end_time = end_hour_time.to_i * 1000
		# p "end_time #{end_time}"
		start_time = start_hour_time.to_i * 1000
		# p "start_time #{start_time}"
		bucket_ms = 1000*3600
		
		data = HTTParty.get(EXPLORER_API+ "gettransactionsbyintervals?start=#{start_time}&end=#{end_time}&interval=#{bucket_ms}")

		raw_data =  data.parsed_response
	end

	def number_of_cc_tx_by_dates(start_day,end_day)

		raw_start_time = Time.parse(start_day)
		# p "raw_start_time #{raw_start_time}"		
		raw_end_time = Time.parse(end_day)+3600*24
		# p "raw_end_time #{raw_end_time}"		
		start_time = raw_start_time.to_i * 1000
		# p "start_time #{start_time}"
		end_time = raw_end_time.to_i * 1000
		# p "end_time #{end_time}"

		bucket_ms = 1000*3600*24
		
		data = HTTParty.get(EXPLORER_API+ "gettransactionsbyintervals?start=#{start_time}&end=#{end_time}&interval=#{bucket_ms}")

		raw_data =  data.parsed_response
	end	
end

