require __dir__+'/../setup'

stream = 'GMgit0FL'

data = number_of_cc_tx_by_hour(24)

parsed_data = data.map do |x|	
	hash = {"number" => x["txsSum"], "timestamp" => x["from"]/1000}
	JSON.parse(hash.to_json)
end

UPDATE.clear(stream)
UPDATE.push_line(stream,parsed_data)