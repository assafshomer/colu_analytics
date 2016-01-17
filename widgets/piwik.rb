require __dir__+'/../setup'

filter_limit = 9999
format = 'json'
token_auth = APP_CONFIG['piwik_auth_token']
date = '2016-01-16'
period = 'day'

piwik_base = "https://analytics.colu.co/?module=API&method=Actions.getPageUrls&idSite=7&format=#{format}&filter_limit=#{filter_limit}&token_auth=#{token_auth}"

piwik_url = piwik_base + "&date=#{date}&period=#{period}&segment=pageUrl%3D@build_finance"


response = HTTParty.get(piwik_url).parsed_response

p hits = response.map{|r| r['nb_hits']}.inject(:+)


stream = 'c537e9c563'

result = []

7.times do |n|	
	curdate = Time.at(Time.now.to_i - 3600*24*n)
	piwik_url = piwik_base + "&date=#{curdate.strftime("%Y-%m-%d")}&period=day&segment=pageUrl%3D@build_finance"
		response = HTTParty.get(piwik_url).parsed_response
		hits = response.map{|r| r['nb_hits']}.inject(:+)
		hash = {"number" => hits, "timestamp" => curdate.to_i}
		p hash
		result << JSON.parse(hash.to_json)		
end

p result


UPDATE.clear(stream)
UPDATE.push_line(stream,result)

=begin
"https://analytics.colu.co/?module=API&method=Actions.getPageUrls&idSite=7&date=today&period=week&format=json&filter_limit=10&token_auth=04ed96c9526091a248bc30f4dff36ed6&segment=pageTitle%3D%3Dengine.transmit_financed"
=end