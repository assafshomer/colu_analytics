require '../setup'
require __dir__+'/../helpers/explorer_helper'
include ExplorerHelper

	raw_data = number_of_cc_tx_by_dates('10/01/2016','14/01/2016')
	p raw_data
	nice_data = raw_data.map do |x|
		{from: Time.at(x["from"]/1000), till: Time.at(x["untill"]/1000), tx: x["txsSum"]}
	end	

	p nice_data

# p result.flatten.map{|e| [e[:from].strftime("%B")+' '+e[:from].strftime("%Y"),e[:tx]]}
