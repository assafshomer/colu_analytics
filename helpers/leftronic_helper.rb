# require './setup'
# module LeftronicHelper

# 	def clear_widget(stream)
# 		clear_cmd = %Q{#{CURL} '{"accessKey": "#{KEY}", "streamName": "#{stream}", "command": "clear" }' #{URL}}
# 		system clear_cmd
# 	end
	
# 	def push_point(stream,data)
# 		# expects array in the format [{"timestamp":1434612076, "number": 123},{"timestamp":1445325918, "number": 456}]
# 		data_cmd = %Q{#{CURL} '{"accessKey": "#{KEY}", "streamName": "#{stream}", "point": #{data} }' #{URL}}
# 		system data_cmd
# 	end	

# end

