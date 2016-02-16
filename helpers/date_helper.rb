require 'time'
require 'active_support/time'

module DateHelper
	def dates_are_numbers(start_day,end_day = nil)
		# expecting start day in format '14/01/2016', returns the integer time reps spanning 00:00 start day to midnight end day
		end_day = Time.now.strftime("%d/%m/%Y") unless end_day
		raw_start_time = Time.parse(start_day)
		start_time = raw_start_time.to_i * 1000
		raw_end_time = Time.parse(end_day)+3600*24
		end_time = raw_end_time.to_i * 1000
		# p Time.at(start_time/1000)
		# p Time.at(end_time/1000)
		return {from: start_time, till: end_time}		
	end

	def days_are_numbers(limit=0,offset=0)
		# returns the integer time reps spanning 00:00 start day to midnight end day. be default talking about today. If limit > 0 start day is limit days before start day. If offset > 0 end day is offset days before.
		end_day = Time.at(Time.now.to_i - 3600*24*offset).strftime("%d/%m/%Y")
		start_day = Time.at(Time.now.to_i - 3600*24*(offset+limit)).strftime("%d/%m/%Y")
		raw_end_time = Time.parse(end_day)+3600*(24 - hour_offset_to_israel) 
		raw_start_time = Time.parse(start_day) - 3600*hour_offset_to_israel
		end_time = raw_end_time.to_i * 1000
		start_time = raw_start_time.to_i * 1000
		p Time.at(start_time/1000)
		p Time.at(end_time/1000)		
		return {from: start_time, till: end_time}		
	end

	def hours_are_numbers(opts={})
		num_hours = opts[:limit] || 24
		start_num_hours_ago = opts[:offset] || 0
		start_time = Time.now - (start_num_hours_ago + num_hours).hours
		end_time = Time.now - start_num_hours_ago.hours
		return {from: start_time.to_i*1000, till: end_time.to_i*1000}
	end

	def group_by_day(array_of_hashes_with_time_key)
		array_of_hashes_with_time_key.group_by do |element|
			Time.at(element[:time]/1000).strftime("%d/%m/%Y")
		end
	end
	def group_by_hour(array_of_hashes_with_time_key)
		array_of_hashes_with_time_key.group_by do |element|
			Time.at(element[:time]/1000).strftime("%d/%m/%Y %H:00")
		end
	end
	def hour_offset_to_israel
		Time.now.in_time_zone('Jerusalem').strftime("%z").to_i/100 - Time.now.strftime("%z").to_i/100
	end
	def timestamp
		Time.now.in_time_zone('Jerusalem').strftime("%H:%M")
	end
	def datestamp(days_ago = 0)
		(Time.now.in_time_zone('Jerusalem')+days_ago.to_i.days).strftime("%Y-%m-%d")
	end	
end