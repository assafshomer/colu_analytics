
module ViewsHelper

	def time_diff_milli(start, finish=Time.now)
		((finish - start) * 1000.0).round
	end
	def time_diff(start, finish=Time.now)
		t = (finish - start).round
		"%02d:%02d:%02d" % [t/3600%24, t/60%60, t%60]
	end
	def print_box(string)
		line = starting = "***   #{string}   ***"
		wrapper = "*"*(line.length+1)
		puts wrapper
		puts line
		puts wrapper
	end
end

