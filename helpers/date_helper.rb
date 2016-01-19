require 'time'

module DateHelper
	def days_are_numbers(start_day,end_day = nil)
		# expecting start day in format '14/01/2016', returns the integer time reps spanning 00:00 start day to midnight end day
		end_day = Time.now.strftime("%d/%m/%Y") unless end_day
		raw_start_time = Time.parse(start_day)
		start_time = raw_start_time.to_i * 1000
		raw_end_time = Time.parse(end_day)+3600*24
		end_time = raw_end_time.to_i * 1000
		return {from: start_time, till: end_time}		
	end
end