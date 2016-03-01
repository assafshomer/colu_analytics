require __dir__+'/../../setup'

require __dir__+'/../../helpers/npm_helper'
include NpmHelper

streams = {colu: 'sMa24kDU'}

number_of_months = 8
timeout = 90
# debug = true

streams.keys.each do |package|
	print_box "Processing #{package}"
	begin
	  Timeout::timeout(timeout) do			
			result = []
			number_of_months.times do |month|
				downloads = downloads_in_month(offset: month+1)
				start_time = Time.parse(downloads["start"])
				month_name = start_time.strftime("%B")[0..2]
				year_name = start_time.strftime("%Y")
				current_year = Time.now.strftime("%Y")
				color = (year_name == current_year) ? "#cb3837" : '#7a7a7a'				
				result << {name: month_name, value: downloads["downloads"],color: color}
			end
			point =  {"chart": result.flatten.reverse }
			stream = streams[package]
			UPDATE.clear(stream)
			UPDATE.push_line(stream,point)  		
	  end
	rescue Timeout::Error
		p "#{filename(__FILE__).upcase} (#{package.upcase}) timed out after #{timeout} seconds"
	end		
end