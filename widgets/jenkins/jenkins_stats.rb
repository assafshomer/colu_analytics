require __dir__+'/../../setup'
require __dir__+'/../../helpers/jenkins_helper'
include JenkinsHelper

# puts JENKINS.job.list("^Test")
request = 	last_build_url('Test-GetData-MainNet')

puts JENKINS.api_get_request(request)