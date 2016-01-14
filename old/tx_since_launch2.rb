require './setup'

stream = 'H2L1ArR6'

# Number of tx since launch
num_of_days = 365
ms_in_hour = 1000 * 60 * 60
duration_ms = ms_in_hour * 24 * num_of_days
end_time = Time.now.to_i*1000
start_time = end_time - duration_ms
group_by_number_of_hours = 24 * 31
bucket_ms = ms_in_hour * group_by_number_of_hours

raw_tx_data = HTTParty.get(EXPLORER_API+ "gettransactionsbyintervals?start=#{start_time}&end=#{end_time}&interval=#{bucket_ms}")

parsed_data = raw_tx_data.parsed_response.map do |d|
	hash = {"number" => d["txsSum"].to_i, "timestamp" => d["from"].to_i/1000 }
	JSON.parse(hash.to_json)
end
p parsed_data
UPDATE.clear(stream)
UPDATE.push_line(stream,parsed_data)