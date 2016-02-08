require __dir__+'/../../setup'

require __dir__+'/../../helpers/explorer_helper'
include ExplorerHelper

mainnet_stream = 'ZrHESsg0'
testnet_stream = '20d74d0960'

mainnet = true
testnet = true

number_of_months = 8
timeout = 90

begin
  Timeout::timeout(timeout) do
  	if mainnet
  		network = :mainnet
			result = []
			number_of_months.times do |month|
				raw_month_data = number_of_cc_tx_in_month(offset: month,network: network)
				nice_data = raw_month_data.map do |x|
					start_time = Time.at(x["from"]/1000)
					month_name = start_time.strftime("%B")[0..2]
					year_name = start_time.strftime("%Y")
					current_year = Time.now.strftime("%Y")
					color = (year_name == current_year) ? "#{color(network)}" : '#7a7a7a'
					{name: month_name, value: x["txsSum"],color: color}
				end.flatten
				result << nice_data
			end

			point =  {"chart": result.flatten.reverse }

			UPDATE.clear(mainnet_stream)
			UPDATE.push_line(mainnet_stream,point)	  		
  	end

  	if testnet
  		network = :testnet
			result = []
			number_of_months.times do |month|
				raw_month_data = number_of_cc_tx_in_month(offset: month,network: network)
				nice_data = raw_month_data.map do |x|
					start_time = Time.at(x["from"]/1000)
					month_name = start_time.strftime("%B")[0..2]
					year_name = start_time.strftime("%Y")
					current_year = Time.now.strftime("%Y")
					color = (year_name == current_year) ? "#{color(network)}" : '#7a7a7a'
					{name: month_name, value: x["txsSum"],color: color}
				end.flatten
				result << nice_data
			end

			point =  {"chart": result.flatten.reverse }

			UPDATE.clear(testnet_stream)
			UPDATE.push_line(testnet_stream,point)	  		
  	end  	
  end
rescue Timeout::Error
	p "Explorer call timed out after #{timeout} seconds"
end

