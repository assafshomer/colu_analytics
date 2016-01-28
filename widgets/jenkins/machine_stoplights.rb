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

mainnet_stream = '16wEAwnS'
testnet_stream = '84122883e1'

UPDATE.push_number mainnet_stream, status_to_i(mainnet_status)
UPDATE.push_number testnet_stream, status_to_i(testnet_status)

