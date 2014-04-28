# -*- encoding : utf-8 -*-
require 'spec_helper'

# Author:: jlopezn@neonline.cl
describe BingAdsApi do

	before :all do
		@username = ""
		@password = ""
		@developer_token = ""
		@customer_id = ""
		@account_id = ""
		@auth_token = ""
	end

	it "load config" do
		config = BingAdsApi::Config.instance
		expect(config).not_to be_nil
		expect(config.config).not_to be_nil
	end

	it "config constants" do
		config = BingAdsApi::Config.instance

		expect(config.common_constants).not_to be_nil
		expect(config.campaign_management_constants).not_to be_nil
		expect(config.reporting_constants).not_to be_nil
	end

	it "config common constants" do
		config = BingAdsApi::Config.instance
		expect(config.common_constants['time_zones']).not_to be_nil
		expect(config.common_constants['time_zones']['santiago']).not_to be_nil
	end

	it "get sandbox wsdl" do
		config = BingAdsApi::Config.instance

		expect(config.service_wsdl(:sandbox, :campaign_management)).not_to be_nil
		expect(config.service_wsdl(:sandbox, :reporting)).not_to be_nil
	end

	it "get production wsdl" do
		config = BingAdsApi::Config.instance

		expect(config.service_wsdl(:production, :campaign_management)).not_to be_nil
		expect(config.service_wsdl(:production, :reporting)).not_to be_nil
	end

	it "create client proxy" do
		options = {
			:username => @username,
			:password => @password,
			:developer_token => @developer_token,
			:customer_id => @customer_id,
			:account_id => @account_id,
			:wsdl_url => "https://api.sandbox.bingads.microsoft.com/Api/Advertiser/CampaignManagement/v9/CampaignManagementService.svc?singleWsdl"
		}
		client = BingAdsApi::ClientProxy.new(options)

		expect(client).not_to be_nil
		expect(client.service).not_to be_nil
	end

	it "create client proxy with additional settings" do
		options = {
			:username => @username,
			:password => @password,
			:developer_token => @developer_token,
			:customer_id => @customer_id,
			:account_id => @account_id,
			:wsdl_url => "https://api.sandbox.bingads.microsoft.com/Api/Advertiser/CampaignManagement/v9/CampaignManagementService.svc?singleWsdl",
			:proxy => {
				:logger => Logger.new(STDOUT),
				:encoding => "UTF-8"
			}
		}
		client = BingAdsApi::ClientProxy.new(options)

		expect(client).not_to be_nil
		expect(client.service).not_to be_nil
	end

	it "call service" do
		options = {
			:username => @username,
			:password => @password,
			:developer_token => @developer_token,
			:customer_id => @customer_id,
			:account_id => @account_id,
			:wsdl_url => "https://api.sandbox.bingads.microsoft.com/Api/Advertiser/CampaignManagement/v9/CampaignManagementService.svc?singleWsdl"
		}

		client = BingAdsApi::ClientProxy.new(options)
		expect(client).not_to be_nil

		response = client.service.call(:get_campaigns_by_account_id,
			message: { Account_id: client.account_id})
		expect(response).not_to be_nil
	end

	it "create and call from config" do
		config = BingAdsApi::Config.instance
		options = {
			:username => @username,
			:password => @password,
			:developer_token => @developer_token,
			:customer_id => @customer_id,
			:account_id => @account_id,
			:wsdl_url => config.service_wsdl(:sandbox, :campaign_management)
		}

		client = BingAdsApi::ClientProxy.new(options)
		expect(client).not_to be_nil

		response = client.service.call(:get_campaigns_by_account_id,
			message: { Account_id: client.account_id})
		expect(response).not_to be_nil
	end

end
