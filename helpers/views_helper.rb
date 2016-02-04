
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
	def shorten_country(country_full)
		c = case country_full
		when 'United Kingdom'
			'UK'
		else
			country_full
		end
		c.length > 8 ? c[0..8]+'...' : c
	end
	def create_multiline_title(array_of_hashes,list_of_keys)
		summary = array_of_hashes.map do |h|
			output = {}
			list_of_keys.each do |k|
				output[k] = h[k] if h.keys.include?(k)
			end
			output
		end.uniq

		c = '&#013;&#xA;'

		title = ""
		summary.each do |line|
			line.each do |k,v|
				title << "#{k.upcase}: [#{v}], "
			end
			title = title[0..-3]
			title += c
		end
		return title
	end

end

