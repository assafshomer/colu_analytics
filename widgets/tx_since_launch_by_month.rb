require '../setup'

stream = 'H2L1ArR6'

data = []
12.times do |month|
	month_data = number_of_cc_tx_in_month(month)
	data << month_data
end

parsed_data = data.map do |d|	
	x = d.first
	hash = {"number" => x["txsSum"], "timestamp" => x["from"]/1000}
	JSON.parse(hash.to_json)
end

UPDATE.clear(stream)
UPDATE.push_line(stream,parsed_data)