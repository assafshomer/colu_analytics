require '../setup'

	raw_data = foo(50)
	p raw_data
	nice_data = raw_data.map do |x|
		{from: Time.at(x["from"]/1000), till: Time.at(x["untill"]/1000), tx: x["txsSum"]}
	end	

	p nice_data

# p result.flatten.map{|e| [e[:from].strftime("%B")+' '+e[:from].strftime("%Y"),e[:tx]]}
