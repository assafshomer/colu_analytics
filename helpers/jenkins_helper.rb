
require 'jenkins_api_client'
require 'active_support/time'

module JenkinsHelper
	JENKINS = JenkinsApi::Client.new(
		server_ip: APP_CONFIG['jenkins_ip'],
		username: APP_CONFIG['jenkins_username'],
		password: APP_CONFIG['jenkins_password']
		)

	def last_build_url(job_name)
		"/job/#{job_name}/lastBuild/api/json"
	end

	def translate_status(status)
		case status
		when 'SUCCESS'
			"UP (#{timestamp})"
		when "FAILURE"
			"DOWN (#{timestamp})"
		else
			"N/A (#{timestamp})"
		end		
	end

	def timestamp
		Time.now.in_time_zone('Jerusalem').strftime("%H:%M")
	end

end
