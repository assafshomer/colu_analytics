require __dir__+'/../../setup'
require __dir__+'/../../helpers/jenkins_helper'
include JenkinsHelper
include ViewsHelper
require __dir__+'/../../helpers/api_helper'
include ApiHelper	
require 'active_support/inflector'
# puts JENKINS.job.list("^Test")

streams = {mainnet: '16wEAwnS', testnet: '84122883e1'}
timeout = {mainnet: 30, testnet: 30}

[:mainnet, :testnet].each do |network|
	# next if network == :mainnet
	print_box("Processing #{network}")
	begin
	  Timeout::timeout(timeout[network]) do	
	  	request = last_build_url("Ping-Explorer-#{network.to_s.camelize}")
			p "Getting #{network} Machine Status from Jenkins"
			p status = query_jenkins_api(request)['result']
			stream = streams[network]
			UPDATE.clear(stream)
			UPDATE.push_number(stream,status_to_i(status))	
	  end
	rescue Timeout::Error
		p "#{filename(__FILE__).upcase} (#{network.upcase}) timed out after #{timeout} seconds"
	end		
end