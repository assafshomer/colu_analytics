module LeftronicHelper
	def prepare_point(number,timestamp)
		h={"number" => number, "timestamp" => timestamp}
		JSON.parse(h.to_json)
	end	

end
