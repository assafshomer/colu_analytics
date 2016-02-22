

module ViewsHelper	
	require 'countries/iso3166'
	def time_diff_milli(start, finish=Time.now)
		((finish - start) * 1000.0).round
	end
	def time_diff(start, finish=Time.now)
		t = (finish - start).round
		"%02d:%02d:%02d" % [t/3600%24, t/60%60, t%60]
	end
	def print_box(string,title=nil)		
		wrapper = "\n"+"#"*60+"\n"
		puts wrapper
		puts title.upcase if title
		puts string
		puts wrapper
	end
	def abbreviate(string,length)
		string = string.to_s
		if string.length < length
			return string
		else
			return string[0..length-3]+'..'
		end
	end
	def shorten_country(country_full)
		c = case country_full
		when 'United Kingdom'
			'UK'
		else
			country_full
		end
		abbreviate(c,8)
	end
	def list_countries_alpha2(piwik_data)
		piwik_data.map do |dp|
			iso3166_alpha2(dp[:country])
		end.uniq.join(',')
	end

	def iso3166_alpha2(country)
		c = ISO3166::Country.find_country_by_name(country) 
		c.alpha2
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

	def color(network)
		case network
		when :mainnet
			"rgb(0, 189, 255)"
		when :testnet
			"rgb(0, 255, 136)"
		else
			puts "[#{network}] is not a recognized bitcoin network, using mainnet color instead"
			"rgb(0, 189, 255)"
		end
	end

	def write_pair(p,b=binding)
	  eval("
	    local_variables.each do |v| 
	      if eval(v.to_s + \".object_id\") == " + p.object_id.to_s + "
	        puts v.to_s + ': ' + \"" + p.to_s + "\"
	      end
	    end
	  " , b)
	end	

end