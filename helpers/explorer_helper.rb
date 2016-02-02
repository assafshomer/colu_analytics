module ExplorerHelper
	require __dir__+'/views_helper'
	include ViewsHelper
	require __dir__+'/date_helper'
	include DateHelper	
	require 'launchy'

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
		
		query(start_time,end_time,bucket_ms)
	end

	def number_of_cc_tx_in_last_hours(hours=24)
		ms_in_hour = 1000 * 60 * 60
		duration_ms = ms_in_hour * hours.to_i
		end_time = Time.now.to_i*1000
		start_time = end_time - duration_ms
		group_by_number_of_hours = 1
		bucket_ms = ms_in_hour * group_by_number_of_hours
		
		query(start_time,end_time,bucket_ms)
	end

	def number_of_cc_tx_by_hour(hours = 0)
		# by defaults gives total number of CC tx in last hour. if you set hours gives hourly since hours ago
		now = Time.now
		now_hour_number = now.strftime("%H").to_i
		now_day = now.strftime("%d")
		raw_start_time = now - 3600 * hours
		start_hour_number = raw_start_time.strftime("%H").to_i
		start_day = raw_start_time.strftime("%d")
		next_hour_number = (now_hour_number % 24) + 1
		next_hour_day = now_hour_number == 24 ? now_day.to_i + 1 : now_day
		start_hour_time = Time.parse("#{start_day} #{start_hour_number}")
		end_hour_time = Time.parse("#{next_hour_day} #{next_hour_number}")
		end_time = end_hour_time.to_i * 1000
		start_time = start_hour_time.to_i * 1000
		bucket_ms = 1000*3600
		query(start_time,end_time,bucket_ms)
	end

	def number_of_cc_tx_by_dates(start_day,end_day=nil)
		times = dates_are_numbers(start_day,end_day)
		# p Time.at(times[:from]*1000)
		# p Time.at(times[:till]*1000)
		# 24h buckets
		bucket_miliseconds = 1000*3600*24
		query(times[:from],times[:till],bucket_miliseconds)
	end

	def total_number_of_cc_tx_by_days(limit=0,offset=0)
		times = days_are_numbers(limit,offset)
		# one bucket
		bucket_miliseconds = 1000*3600*24*(limit+1)
		result = query(times[:from],times[:till],bucket_miliseconds)
		return result.first['txsSum']
	end

	def get_cc_tx_last_days(limit=0,offset=0,debug=false)
		init_time = Time.now
		num_of_tx = total_number_of_cc_tx_by_days(limit,offset)
		p "Total number of cc tx in this period: #{num_of_tx}"
		result = []
		num_of_tx.times.each_slice(100).each_with_index do |s,i|
			endpoint = "getcctransactions?limit=#{s.last-s.first}&skip=#{s.first}"
			query = EXPLORER_API+ endpoint
			init_time = Time.now
			p "Calling Explorer API with [#{query}]" if debug
			data = HTTParty.get(query)
			p "Explorer API replied [#{time_diff(init_time)}]" if debug
			raw_data = data.parsed_response
			batch = raw_data.map{|tx| {
				# txid: tx['txid'],
				time: tx['blocktime'],
				# pretty_time: Time.at(tx['blocktime']/1000),
				type: tx['ccdata'].first['type'],
				asset_ids: tx['vout'].map{|x| x['assets']}.flatten.map{|e| e["assetId"] if e}.compact.uniq
				}}
			File.write("#{__dir__}/../data/#{endpoint}.json",batch.to_json) if debug
			result << batch
		end
		result.flatten
	end

	def query(start_time,end_time,bucket_ms,debug=true)
		init_time = Time.now
		query = EXPLORER_API+ "gettransactionsbyintervals?start=#{start_time}&end=#{end_time}&interval=#{bucket_ms}"		
		p "start_time: #{start_time} [#{Time.at(start_time/1000)}], end_time: #{end_time} [#{Time.at(end_time/1000)}]" if debug
		p "Calling Explorer API with [#{query}]" if debug
		data = HTTParty.get(query)
		p "Explorer API replied [#{time_diff(init_time)}]" if debug
		raw_data =  data.parsed_response		
	end

	def order_asset_ids(raw_data)
		assetids = raw_data.map{|e| e.reject{|k,v| k!=:asset_ids}}.map{|e| e[:asset_ids]}.flatten
		counted_asset_ids = assetids.group_by{|a| a}.map{|k,v| {"#{k}": v.count}}
		counted_asset_ids.sort_by{|e| e[e.keys.first]}.reverse		
	end

	def prepare_asset_leaderboard(ordered_asset_ids)
		html_start = '<!DOCTYPE html><html><head><title></title></head><body>'
		html_end = '</body></html>'
		max_length = 25
		result = html_start
		result << %Q(<div class="widgetTitle lt-widget-title" style="left: 20.65px; font-size: 23px; line-height: 59px;color:rgb(204, 204, 204);"><h1>Leading Assets since midnight <div style="float:right;font-size:14px;">(updated: #{timestamp})</div></h1></div>)
		ordered_asset_ids.each do |data_point|
			asset_id = data_point.keys.first
			short_asset_id = asset_id[0..20]+'...'
			metadata = get_asset_metadata(asset_id)			
			display_name = metadata ? metadata['assetName'].to_s : short_asset_id
			display_name = display_name.empty? ? short_asset_id : display_name
			display_name = display_name.length > max_length ? display_name[0..max_length]+'...' : display_name
			issuer_name = metadata ? metadata['issuer'] : ''
			asset_desc = metadata ? metadata['description'] : ''
			p "name: #{display_name}, issuer: #{issuer_name}, desc: #{asset_desc}"
			frequency = data_point[asset_id]
			title = %Q(#{display_name} issued by #{issuer_name} #{asset_desc})
			line = %Q(<p><div style="line-height:35px; height:50px; font-size:28px;border-top-style: solid;clear: both;border-top-width: 1px;border-top-color:#4d4d4d;"><a href="http://coloredcoins.org/explorer/asset/#{asset_id}" target="_blank" style="color:rgb(0, 189, 255); right:20.65px; text-decoration:none;float:left;margin-top:6px;">#{display_name}</a> <div style="color:rgb(204, 204, 204);float:right;text-align:right;margin-top:6px;">#{frequency}</div></div></p>)
			result << line
		end
		result << html_end
		# path = "#{__dir__}/../data/asset_leaderboard.html"
		# File.write(path,result)
		# Launchy.open(path)
	end

	def prepare_new_asset_leaderboard(asset_data)
		html_start = '<!DOCTYPE html><html><head><title></title></head><body>'
		html_end = '</body></html>'		
		result = html_start
		result << %Q(<p><div class="widgetTitle lt-widget-title" style="left: 20.65px; font-size: 26px; line-height: 59px;color:rgb(204, 204, 204);"><h1>Leading Assets since midnight <div style="float:right;font-size:14px;">(updated: #{timestamp})</div></h1></div></p>)
		result << %Q(
			<p>
				<div style="color:gray;padding-bottom:20px;text-align:center;">
					<div style="width:200px;float:left">Asset</div>
					<div style="float:left;"> #tx </div>
					<div style="float:left;width:110px;">Country</div>
					<div style="float:left;width:30px;">flag</div>
					<div style="float:left;width:150px;">IP</div>
					<div style="float:left;width:120px;">Issuer</div>
				</div>
			</p>
		)
		asset_data.each do |dp|
			flag = dp[:flag] ? %Q(<img title="#{dp[:country]}" alt="#{dp[:country]}" width="16" height="11" src="https://analytics.colu.co/#{dp[:flag]}">) : ''
			city = dp[:city] ? dp[:city] : 'Unknown City'
			title = %Q(#{dp[:display_name]} issued by #{dp[:issuer_name]} #{dp[:asset_desc]})
			line = %Q(
				<p>
					<div style="line-height:35px; height:50px; border-top-style: solid;clear: both;border-top-width: 1px;border-top-color:#4d4d4d;">
						<div style="font-size:24px;">
							<a href="http://coloredcoins.org/explorer/asset/#{dp[:asset_id]}" target="_blank" style="color:rgb(0, 189, 255); right:20.65px; text-decoration:none;float:left;margin-top:6px;width:200px;" title="#{dp[:asset_desc]}">
							#{dp[:display_name]}
							</a>
						</div>
						<div style="font-size:18px;">
							<div style="color:rgb(204, 204, 204);float:left;text-align:left;margin-top:6px;font-size:24px">
							#{dp[:frequency]}
							</div>
							<div style="color:rgb(204, 204, 204);float:left;text-align:left;margin-top:6px;padding-left:10px;padding-right:10px;width:100px;" title="#{city}">
								#{dp[:country]}
							</div>				
							<div style="float:left;margin-top:6px;width:20px;">
								#{flag}
							</div>
							<div style="color:rgb(204, 204, 204);float:left;text-align:left;margin-top:6px;padding-left:10px;width:120px;">
								#{dp[:ip]}
							</div>
							<div style="color:rgb(204, 204, 204);float:left;text-align:left;margin-top:6px;padding-left:20px;">
								#{dp[:issuer_name]}
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

	def get_asset_metadata(asset_id)
		issuances = query_explorer_api("getassetinfowithtransactions?assetId=#{asset_id}")['issuances'].first
		txid = issuances['txid']
		vout = issuances['vout'].select do |vout|
			!vout['assets'].empty? 
			# vout['assets'].first['assetId'] == asset_id
		end.first
		index = vout['n']
		asset_metadata = query_cc_api("assetmetadata/#{asset_id}/#{txid}%3A#{index}")
		metadata = asset_metadata['metadataOfIssuence']['data'] if asset_metadata['metadataOfIssuence'] && asset_metadata['metadataOfIssuence']['data'] 
		return metadata
	end

	def query_explorer_api(endpoint, debug=true)
		init_time = Time.now
		query = EXPLORER_API+ endpoint		
		p "Calling Explorer API with [#{query}]" if debug
		data = HTTParty.get(query)
		p "Explorer API replied [#{time_diff(init_time)}]" if debug
		data.parsed_response			
	end

	def query_cc_api(endpoint, debug=true)
		init_time = Time.now
		query = CC_API+ endpoint		
		p "Calling CC API with [#{query}]" if debug
		data = HTTParty.get(query)
		p "CC API replied [#{time_diff(init_time)}]" if debug
		data.parsed_response			
	end

end

