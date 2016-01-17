require __dir__+'/../setup'

stream = '00323f702a'

data = number_of_cc_tx_by_dates('12/01/2016')

parsed_data = data.map do |x|	
	hash = {"number" => x["txsSum"], "timestamp" => x["from"]/1000}
	JSON.parse(hash.to_json)
end

UPDATE.clear(stream)
UPDATE.push_line(stream,parsed_data)