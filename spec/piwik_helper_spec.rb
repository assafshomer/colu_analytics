require 'spec_helper'
require __dir__+'/../setup.rb'

require __dir__+'/../helpers/piwik_helper.rb'
include PiwikHelper

describe "PiwikHelper" do

	describe 'generate_piwik_api_url' do
		it 'should begin with base' do
			generate_piwik_api_url.index(PIWIK_BASE).should == 0			
		end
	end
	describe 'piwiki visitor profile url' do
		let(:m) { 'Live.getVisitorProfile' }
		it 'should get the visitor url' do			
			generate_piwik_api_url(method: m,params: "&visitorId=foo").split('&').index('visitorId=foo').should > 0
		end	  
	end
	describe 'piwik_link_to_user_profile' do
		it 'should get the visitor url' do			
			piwik_link_to_user_profile("foo").index('visitorId=foo').should_not be_nil
		end		  
	end

end