
require 'jenkins_api_client'
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
			"UP (#{Time.now.strftime("%H:%M")})"
		when "FAILURE"
			"DOWN (#{Time.now.strftime("%H:%M")})"
		else
			"N/A (#{Time.now.strftime("%H:%M")})"
		end		
	end

end
