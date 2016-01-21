require __dir__+'/../../setup'

require __dir__+'/../../helpers/explorer_helper'
include ExplorerHelper

stream = 'GMgit0FL'

data = number_of_cc_tx_by_hour(24)

parsed_data = data.map do |x|	
	hash = {"number" => x["txsSum"], "timestamp" => x["from"]/1000}
	JSON.parse(hash.to_json)
end
p parsed_data

UPDATE.clear(stream)
UPDATE.push_line(stream,parsed_data)