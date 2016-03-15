require __dir__+'/../../setup'

require __dir__+'/../../helpers/explorer_helper'
include ExplorerHelper

streams = {mainnet: 'ZrHESsg0', testnet: '20d74d0960'}

number_of_months = 8
timeout = 90
debug = true

[:mainnet, :testnet].each do |network|
	# next unless network == :testnet
	print_box "Processing #{network}"
	begin
	  Timeout::timeout(timeout) do			
			result = []
			number_of_months.times do |month|
				raw_month_data = number_of_cc_tx_in_month(offset: month,network: network,debug: debug)
				nice_data = raw_month_data.map do |x|
					start_time = Time.at(x["from"]/1000)
					month_name = start_time.strftime("%B")[0..2]
					year_name = start_time.strftime("%Y")
					current_year = Time.now.strftime("%Y")
					color = (year_name == current_year) ? "#{color(network)}" : '#7a7a7a'
					value = x["txsSum"]
					#################################################
					# Dudu asked for the two lines below to fix the fact that apparently many tx that were unconfirmed in February were Confirmed on march 3rd, suddenly moving from Feb to Mar which makes the graph look less attractive
					value = value -2000 if network == :testnet && current_year == '2016' && month_name == 'Mar'
					value = value +2000 if network == :testnet && current_year == '2016' && month_name == 'Feb'
					#################################################
					{name: month_name, value: value,color: color}
				end.flatten
				result << nice_data
			end
			point =  {"chart": result.flatten.reverse }
			stream = streams[network]
			UPDATE.clear(stream)
			UPDATE.push_line(stream,point)  		
	  end
	rescue Timeout::Error
		p "#{filename(__FILE__).upcase} (#{network.upcase}) timed out after #{timeout} seconds"
	end		
end