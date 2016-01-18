require __dir__+'/../../setup'
require __dir__+'/../../helpers/jenkins_helper'
include JenkinsHelper

# puts JENKINS.job.list("^Test")
mainnet_request = 	last_build_url('Test-GetData-MainNet')
testnet_request = 	last_build_url('Test-GetData-TestNet')

mainnet_status = JENKINS.api_get_request(mainnet_request)['result']
testnet_status = JENKINS.api_get_request(testnet_request)['result']

pretty_mainnet_status = mainnet_status == 'SUCCESS' ? 'UP' : 'DOWN'
pretty_testnet_status = mainnet_status == 'SUCCESS' ? 'UP' : 'DOWN'
# stream = 'f5524db248'

# point = {"leaderboard": [
# 	{"name": "Mainnet", "value": 1, "suffix": mainnet_status},
# 	{"name": "Testnet", "value": 1, "suffix": testnet_status}
# ]}
# UPDATE.clear(stream)
# UPDATE.push_line(stream,point)


stream = 'JLZKlvnA'
UPDATE.clear(stream)

header_row = ["Network", "Status"]
table_rows = [
	["Mainnet", pretty_mainnet_status],
	["Testnet", pretty_testnet_status]
]

UPDATE.push_table stream, header_row, table_rows



