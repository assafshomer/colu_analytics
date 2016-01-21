require __dir__+'/../../setup'

require __dir__+'/../../helpers/explorer_helper'
include ExplorerHelper

stream = 'ZfLVeunS'
UPDATE.clear(stream)

week_ago = Time.at(Time.now.to_i - 3600*24*7).strftime("%d/%m/%Y")

timeout = 60
begin
  Timeout::timeout(timeout) do
		data = number_of_cc_tx_by_dates(week_ago)

		parsed_data = data.map do |x|	
			hash = {"number" => x["txsSum"], "timestamp" => x["from"]/1000}
			JSON.parse(hash.to_json)
		end

		
		UPDATE.push_line(stream,parsed_data)		
  end
rescue Timeout::Error
	p "Explorer call timed out after #{timeout} seconds"
end	

