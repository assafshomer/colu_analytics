require '../setup'
require __dir__+'/../helpers/explorer_helper'
include ExplorerHelper

result = []
10.times do |month|
	raw_data = number_of_cc_tx_in_month(month)
	nice_data = raw_data.map do |x|
		{from: Time.at(x["from"]/1000), till: Time.at(x["untill"]/1000), tx: x["txsSum"]}
	end	
	p nice_data
	result << nice_data
end

p result.flatten.map{|e| [e[:from].strftime("%B")+' '+e[:from].strftime("%Y"),e[:tx]]}


# p data.map{|p| Time.at(p.first).strftime("%B")}

# p data.map{|p| Time.at(p.first)}

