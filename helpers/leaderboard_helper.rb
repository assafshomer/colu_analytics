module LeaderboardHelper
	require __dir__+'/views_helper'
	include ViewsHelper
	require __dir__+'/date_helper'
	include DateHelper
	require __dir__+'/explorer_helper'
	include ExplorerHelper
	require __dir__+'/piwik_helper'
	include PiwikHelper		

	def order_asset_ids(raw_data)
		assetids = raw_data.map{|e| e.reject{|k,v| k!=:asset_ids}}.map{|e| e[:asset_ids]}.flatten
		counted_asset_ids = assetids.group_by{|a| a}.map{|k,v| {"#{k}": v.count}}
		counted_asset_ids.sort_by{|e| e[e.keys.first]}.reverse		
	end

	def prepare_asset_leaderboard(asset_data, opts={})
		debug = opts[:debug] || true
		network = opts[:network] || :mainnet	
		w = {asset: 300, tx: 30, location: 100,flag:20, ip: 80, issuer: 120,user: 120,piwik_link: 60}
		html_start = '<!DOCTYPE html><html><head><title></title></head><body>'
		html_end = '</body></html>'		
		result = html_start
		result << %Q(<p><div class="widgetTitle lt-widget-title" style="left: 20.65px; font-size: 26px; line-height: 59px;color:rgb(204, 204, 204);"><h1>Leading #{network.to_s.upcase} Assets in the last 24h<div style="float:right;font-size:14px;">(updated: #{timestamp(full: true)})</div></h1></div></p>)
		result << %Q(
			<p>
				<div style="color:gray;padding-bottom:20px;text-align:left;">
					<div style="width:#{w[:asset]}px;float:left;text-align:center;">
						Asset
					</div>
					<div style="float:left;width:#{w[:tx]}px;">
					 #tx 
					</div>
					<div style="float:left;width:#{w[:location]}px;">Location
					</div>				
					<div style="float:left;width:#{w[:flag]}px;margin-left:10px;margin-right:10px;">
						flag
					</div>
					<div style="float:left;width:#{w[:ip]}px;">
						IP
					</div>
					<div style="float:left;width:#{w[:issuer]}px;">
						Issuer
					</div>
					<div style="float:left;width:#{w[:user]}px;">
						User
					</div>					
					<div style="float:right;margin-left:5px;text-align:left;width:#{w[:piwik_link]}px;"><img title="Piwik User Profile" alt="user profile in piwik" width="15" height="15" src="https://www.bayleafdigital.com/wp-content/uploads/2015/07/piwik-icon.png"></div>
				</div>
			</p>
		)
		asset_data.each do |dp|
			flag = dp[:flag] ? %Q(<img title="#{dp[:country]}" alt="#{dp[:country]}" width="16" height="11" src="https://analytics.colu.co/#{dp[:flag]}">) : ''
			visitors = dp[:piwik_visitors]
			plink = ''
			visitors.first(3).each do |v|
				plink += %Q(<div style="float:left;padding-right:1px;"><a href="#{piwik_link_to_user_profile(v,network: network)}" target="_blank"><img title="user profile" alt="user profile" width="15" height="15" src="https://www.bayleafdigital.com/wp-content/uploads/2015/07/piwik-icon.png"></a></div>)
			end
			plink += '..' if visitors.count > 2
			# plink = dp[:piwik_visitors] ? %Q(<a href="#{plink_url}" target="_blank"><img title="user profile" alt="user profile" width="15" height="15" src="https://www.bayleafdigital.com/wp-content/uploads/2015/07/piwik-icon.png"></a>) : ''			
			line = %Q(
				<p>
					<div style="line-height:35px; height:50px; border-top-style: solid;clear: both;border-top-width: 1px;border-top-color:#4d4d4d;">
						<div style="font-size:24px;">
							<a href="#{explorer_link_to_asset(dp[:asset_id],network)}" target="_blank" style="color:#{color(network)}; right:20.65px; text-decoration:none;float:left;margin-top:6px;width:#{w[:asset]}px;" title="#{dp[:asset_title]}">
							#{dp[:display_name]}
							</a>
						</div>
						<div style="font-size:18px;">
							<div style="color:rgb(204, 204, 204);float:left;text-align:left;margin-top:6px;font-size:24px;width:#{w[:tx]}px;">
							#{dp[:frequency]}
							</div>
							<div style="color:rgb(204, 204, 204);float:left;text-align:left;margin-top:6px;padding-left:10px;width:#{w[:location]}px;" title="#{dp[:piwik_title]}">
								#{dp[:geo].to_s[0..8]}
							</div>				
							<div style="float:left;margin-top:6px;width:#{w[:flag]}px;">
								#{flag}
							</div>
							<div style="color:rgb(204, 204, 204);float:left;text-align:center;margin-top:6px;padding-left:10px;width:#{w[:ip]}px;font-size:10px;">
								#{dp[:ip]}
							</div>
							<div style="color:rgb(204, 204, 204);float:left;text-align:left;margin-top:6px;width:#{w[:issuer]}px;"  title="#{dp[:issuer_title]}">
								#{dp[:issuer_name]}
							</div>
							<div style="color:rgb(204, 204, 204);float:left;text-align:left;margin-top:6px;width:#{w[:user]}px;font-size:80%;"  title="#{dp[:user_title]}">
								#{dp[:user_name]}
							</div>							
							<div style="float:right;margin-top:6px;width:#{w[:piwik_link]}px;">
								#{plink}
							</div>							
						</div>
					</div>
				</p>)
			result << line
		end
		result << html_end
		# path = "#{__dir__}/../data/asset_leaderboard.html"
		# File.write(path,result)
		# Launchy.open(path)
	end

	def collect_asset_leaderboard_data(opts={})
		debug = opts[:debug] || false
		network = opts[:network] || :mainnet

		number_of_assets = opts[:number_of_assets] || 1
		number_of_days = opts[:number_of_days] || 1
		start_days_past = opts[:start_days_past] || 0

		raw_data = get_cc_tx_last_days(limit: number_of_days-1,offset: start_days_past,debug: debug, network: network)
		# p "#"*60
		# p raw_data
		# p "#"*60
		ordered_asset_ids = order_asset_ids(raw_data).first(number_of_assets)
		curdate = Time.at(Time.now.to_i)
		number_of_piwik_results = 9999
		method = "Live.getLastVisitsDetails"
		visits = piwik_data_during_period(
			method: method, 
			debug: false,
			filter: number_of_piwik_results,
			num_days: number_of_days,
			days_offset: start_days_past,
			network: network
			)
		# Note that I'm using num_of_days and not num_of_days-1 because this gives more piwik data about recent assets, so basically for piwik polling one more days into the past
		# File.write("#{__dir__}/../txt/foo.txt",visits.to_json)
		visits = JSON.parse(visits) if (visits.class == String)
		parsed_piwik_visits = parse_visits(visits)

		data = ordered_asset_ids.map do |data_point|
			max_length = 20
			asset_id = data_point.keys.first
			short_asset_id = abbreviate(asset_id,15)
			metadata = get_asset_metadata(asset_id,{network: network,debug: debug})
			full_name = metadata ? metadata['assetName'].to_s : ''
			display_name = metadata ? metadata['assetName'].to_s : short_asset_id
			display_name = display_name.empty? ? short_asset_id : display_name
			display_name = abbreviate(display_name,max_length)
			issuer_name = metadata ? abbreviate(metadata['issuer'],11) : ''
			issuer_title = metadata ? metadata['issuer'] : ''
			asset_desc = metadata ? metadata['description'] : nil
			desc_for_title =  asset_desc ? "#{asset_desc}" : ''
			p "name: #{display_name}, issuer: #{issuer_name}, desc: #{asset_desc}, asset_id: #{asset_id}" if debug
			asset_title = [{name: full_name},{id: asset_id},{description: desc_for_title}]
			frequency = data_point[asset_id]
			result = {}
			result[:asset_id] ||= asset_id
			result[:frequency] = frequency
			result[:display_name] = display_name
			result[:full_name] = full_name
			result[:issuer_name] = issuer_name
			result[:issuer_title] = issuer_title
			result[:asset_title] = create_multiline_title(asset_title,[:name, :description, :id])
			
			# Add piwik data for asset
			# p "parsed_piwik_visits: #{parsed_piwik_visits}"
			piwik_data = pick_piwik_data_for_asset_id(parsed_piwik_visits,asset_id)
			result[:piwik_visitors] = piwik_data.map{|pd| pd[:piwik_visitors]}
			filtered_data = piwik_data.map{|dp| dp.select{|k,v| !k.to_s.match(/piwik|timestamp/)}}.uniq
			list = [:ip, :country, :city, :asset_id]
			combined_filtered_data = []
			tmp = filtered_data.dup
			tmp.each do |x|
				succint = x.select{|k,v| list.include?(k)}
				combined_filtered_data = filtered_data.map do |fd|
					if fd.select{|k,v| list.include?(k)} == succint
						fd.merge(x)
					else
						fd
					end
				end.uniq
			end			
			if (combined_filtered_data.count == 1)
				piwik_dp = combined_filtered_data.first
				country_full = piwik_dp[:country].to_s				
				country = shorten_country(country_full)
				city = piwik_dp[:city].to_s
				city = city.empty? ? 'Unknown' : city
				result[:geo] = country
				result[:ip] = piwik_dp[:ip]
				result[:flag] = piwik_dp[:flag]
				result[:piwik_title] = "Country: [#{country_full}], City: [#{city}]"
			else
				countries = combined_filtered_data.map{|x| x[:country]}.uniq
				if countries.count == 1
					piwik_dp = combined_filtered_data.first
					country_full = piwik_dp[:country].to_s				
					country = shorten_country(country_full)
					result[:geo] = country
					result[:flag] = piwik_dp[:flag]
				else
					result[:geo] = list_countries_alpha2(combined_filtered_data)
				end		
				result[:piwik_title] = create_multiline_title(combined_filtered_data,[:country,:city,:ip])
			end
			p "result: #{result}" if debug
			result
		end
		p "data: #{data}" if debug
		data
	end
	def collect_asset_leaderboard_data_by_hour(opts={})
		debug = opts[:debug] || false
		network = opts[:network] || :mainnet

		number_of_assets = opts[:number_of_assets] || 1
		number_of_hours = opts[:number_of_hours] || 1
		start_hours_past = opts[:start_hours_past] || 0

		raw_data = get_cc_tx_last_hours(limit: number_of_hours,offset: start_hours_past,debug: debug, network: network)
		# p "#"*60
		# p raw_data
		# p "#"*60
		ordered_asset_ids = order_asset_ids(raw_data).first(number_of_assets)
		curdate = Time.at(Time.now.to_i)
		number_of_piwik_results = 9999
		method = "Live.getLastVisitsDetails"
		visits = piwik_data_during_period(
			method: method, 
			debug: false,
			filter: number_of_piwik_results,
			num_days: 1+(number_of_hours/24).round,
			days_offset: (start_hours_past/24).round,
			network: network
			)
		# Note that I'm using num_of_days and not num_of_days-1 because this gives more piwik data about recent assets, so basically for piwik polling one more days into the past
		# File.write("#{__dir__}/../txt/foo.txt",visits.to_json)
		visits = JSON.parse(visits) if (visits.class == String)
		parsed_piwik_visits = parse_visits(visits)

		data = ordered_asset_ids.map do |data_point|
			max_length = 20
			asset_id = data_point.keys.first
			short_asset_id = abbreviate(asset_id,15)
			metadata = get_asset_metadata(asset_id,network: network,debug: debug)
			full_name = metadata ? metadata['assetName'].to_s : ''
			display_name = metadata ? metadata['assetName'].to_s : short_asset_id
			display_name = display_name.empty? ? short_asset_id : display_name
			display_name = abbreviate(display_name,max_length)
			issuer_name = metadata ? abbreviate(metadata['issuer'],11) : ''
			issuer_title = metadata ? metadata['issuer'] : ''
			asset_desc = metadata ? metadata['description'] : nil
			desc_for_title =  asset_desc ? "#{asset_desc}" : ''
			p "name: #{display_name}, issuer: #{issuer_name}, desc: #{asset_desc}, asset_id: #{asset_id}" if debug
			asset_title = [{name: full_name},{id: asset_id},{description: desc_for_title}]
			frequency = data_point[asset_id]
			result = {}
			result[:asset_id] ||= asset_id
			result[:frequency] = frequency
			result[:display_name] = display_name
			result[:full_name] = full_name
			result[:issuer_name] = issuer_name
			result[:issuer_title] = issuer_title
			result[:asset_title] = create_multiline_title(asset_title,[:name, :description, :id])
			
			# Add piwik data for asset
			# p "parsed_piwik_visits: #{parsed_piwik_visits}"
			piwik_data = pick_piwik_data_for_asset_id(parsed_piwik_visits,asset_id)
			# print_box(piwik_data,'piwik_data')
			vids = piwik_data.map{|pd| pd[:piwik_visitor]}.uniq
			result[:piwik_visitors] = vids
			result[:user_name] = ''
			user_data = get_user_data(vids.first)
			if user_data
				name_for_display = 	if !user_data["user_full_name"].blank?
					user_data["user_full_name"]
				elsif !user_data["user_name"].blank?
					user_data["user_name"]
				elsif !user_data["user_email"].blank?
					user_data["user_email"]
				else
					'N/A'
				end
				result[:user_name] = abbreviate(name_for_display,16)
				h = user_data.map{|k,v| {"#{k}": v}}
				title = create_multiline_title(h,user_data.keys.map{|k| k.to_sym})
				result[:user_title] = title
			end		
			
			filtered_data = piwik_data.map{|dp| dp.select{|k,v| !k.to_s.match(/piwik|timestamp/)}}.uniq
			list = [:ip, :country, :city, :asset_id]
			combined_filtered_data = []
			tmp = filtered_data.dup
			tmp.each do |x|
				succint = x.select{|k,v| list.include?(k)}
				combined_filtered_data = filtered_data.map do |fd|
					if fd.select{|k,v| list.include?(k)} == succint
						fd.merge(x)
					else
						fd
					end
				end.uniq
			end			
			if (combined_filtered_data.count == 1)
				piwik_dp = combined_filtered_data.first
				country_full = piwik_dp[:country].to_s				
				country = shorten_country(country_full)
				city = piwik_dp[:city].to_s
				city = city.empty? ? 'Unknown' : city
				result[:geo] = country
				result[:ip] = piwik_dp[:ip]
				result[:flag] = piwik_dp[:flag]
				result[:piwik_title] = "Country: [#{country_full}], City: [#{city}]"
			else
				countries = combined_filtered_data.map{|x| x[:country]}.uniq
				if countries.count == 1
					piwik_dp = combined_filtered_data.first
					country_full = piwik_dp[:country].to_s				
					country = shorten_country(country_full)
					result[:geo] = country
					result[:flag] = piwik_dp[:flag]
				else
					result[:geo] = list_countries_alpha2(combined_filtered_data)
				end		
				result[:piwik_title] = create_multiline_title(combined_filtered_data,[:country,:city,:ip])
			end
			p "result: #{result}" if debug
			result
		end
		p "data: #{data}" if debug
		data
	end
	# def prepare_simple_asset_leaderboard(ordered_asset_ids)
	# 	html_start = '<!DOCTYPE html><html><head><title></title></head><body>'
	# 	html_end = '</body></html>'
	# 	max_length = 25
	# 	result = html_start
	# 	result << %Q(<div class="widgetTitle lt-widget-title" style="left: 20.65px; font-size: 23px; line-height: 59px;color:rgb(204, 204, 204);"><h1>Leading Assets since midnight <div style="float:right;font-size:14px;">(updated: #{timestamp})</div></h1></div>)
	# 	ordered_asset_ids.each do |data_point|
	# 		asset_id = data_point.keys.first
	# 		short_asset_id = asset_id[0..20]+'...'
	# 		metadata = get_asset_metadata(asset_id)			
	# 		display_name = metadata ? metadata['assetName'].to_s : short_asset_id
	# 		display_name = display_name.empty? ? short_asset_id : display_name
	# 		display_name = display_name.length > max_length ? display_name[0..max_length]+'...' : display_name
	# 		issuer_name = metadata ? metadata['issuer'] : ''
	# 		asset_desc = metadata ? metadata['description'] : ''
	# 		p "name: #{display_name}, issuer: #{issuer_name}, desc: #{asset_desc}"
	# 		frequency = data_point[asset_id]
	# 		title = %Q(#{display_name} issued by #{issuer_name} #{asset_desc})
	# 		line = %Q(<p><div style="line-height:35px; height:50px; font-size:28px;border-top-style: solid;clear: both;border-top-width: 1px;border-top-color:#4d4d4d;"><a href="http://coloredcoins.org/explorer/asset/#{asset_id}" target="_blank" style="color:rgb(0, 189, 255); right:20.65px; text-decoration:none;float:left;margin-top:6px;">#{display_name}</a> <div style="color:rgb(204, 204, 204);float:right;text-align:right;margin-top:6px;">#{frequency}</div></div></p>)
	# 		result << line
	# 	end
	# 	result << html_end
	# 	# path = "#{__dir__}/../data/asset_leaderboard.html"
	# 	# File.write(path,result)
	# 	# Launchy.open(path)
	# end
end

