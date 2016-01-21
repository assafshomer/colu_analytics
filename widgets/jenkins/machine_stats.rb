require __dir__+'/../../setup'
require __dir__+'/../../helpers/jenkins_helper'
include JenkinsHelper
include ViewsHelper
# puts JENKINS.job.list("^Test")
mainnet_request = last_build_url('Test-GetData-MainNet')
testnet_request = last_build_url('Test-GetData-TestNet')

p "Getting Mainnet Machine Status from Jenkins"
init_time = Time.now
p mainnet_reply = JENKINS.api_get_request(mainnet_request)
p mainnet_status = mainnet_reply['result']
p "JENKINS API replied within [#{time_diff(init_time)}]"

p "Getting Testnet Machine Status from Jenkins"
init_time = Time.now
p testnet_reply = JENKINS.api_get_request(testnet_request)
p testnet_status = testnet_reply['result']
p "JENKINS API replied within [#{time_diff(init_time)}]"

# p pretty_mainnet_status = mainnet_status == 'SUCCESS' ? "UP (#{Time.now.strftime("%H:%M")})" : "DOWN (#{Time.now.strftime("%H:%M")})"
# p pretty_testnet_status = testnet_status == 'SUCCESS' ? "UP (#{Time.now.strftime("%H:%M")})" : "DOWN (#{Time.now.strftime("%H:%M")})"

pretty_mainnet_status = translate_status(mainnet_status)
pretty_testnet_status = translate_status(testnet_status)

p "Mainnet: #{pretty_mainnet_status}"
p "Testnet: #{pretty_testnet_status}"

stream = 'JLZKlvnA'

if pretty_mainnet_status || pretty_testnet_status
	
	UPDATE.clear(stream)

	header_row = ["Network", "Status"]
	table_rows = [
		["Mainnet", pretty_mainnet_status],
		["Testnet", pretty_testnet_status]
	]

	UPDATE.push_table stream, header_row, table_rows		
end

