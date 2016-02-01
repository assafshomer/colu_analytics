require '../setup'
require __dir__+'/../helpers/explorer_helper'
include ExplorerHelper

number_of_months = 3

result = []
number_of_months.times do |month|
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

# [["January 2016", 4070], ["December 2015", 2774], ["November 2015", 1644], ["October 2015", 1274], ["September 2015", 1215], ["August 2015", 881], ["July 2015", 581], ["June 2015", 0], ["May 2015", 0], ["April 2015", 0]]