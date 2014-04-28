# -*- encoding : utf-8 -*-
require 'spec_helper'

# Author:: jlopezn@neonline.cl
describe BingAdsApi::CustomerManagement do

	before :all do
		@config = BingAdsApi::Config.instance
		@options = {
			:environment => :sandbox,
			:username => "ruby_bing_ads_sbx",
			:password => "sandbox123",
			:developer_token => "BBD37VB98",
			:customer_id => "21025739",
			:account_id => "8506945"
		}
		@service = BingAdsApi::CustomerManagement.new(@options)
	end

	it "truth" do
		expect(BingAdsApi).to be_kind_of(Module)
	end

	it "initialize" do
		@service = BingAdsApi::CustomerManagement.new(@options)
		expect(@service).not_to be_nil
	end

	it "get accounts info" do
		response = @service.get_accounts_info
		expect(response).not_to be_nil
		expect(response).to be_kind_of(Array)
	end

end
