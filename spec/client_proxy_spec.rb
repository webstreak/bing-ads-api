# -*- encoding : utf-8 -*-
require 'spec_helper'

# Author:: jlopezn@neonline.cl
describe BingAdsApi::ClientProxy do

    let(:default_options) do
        {
            username: "ruby_bing_ads_sbx",
            password: "sandbox123",
            developer_token: "BBD37VB98",
            customer_id: "21025739",
            account_id: "8506945"
        }
    end

    it "should create client proxy" do
        options = {
            username: @username,
            password: @password,
            developer_token: @developer_token,
            customer_id: @customer_id,
            account_id: @account_id,
            wsdl_url: "https://campaign.api.sandbox.bingads.microsoft.com/Api/Advertiser/CampaignManagement/V10/CampaignManagementService.svc?singleWsdl"
        }
        client = BingAdsApi::ClientProxy.new(options)

        expect(client).not_to be_nil
        expect(client.service).not_to be_nil
    end

    it "should create client proxy with additional settings" do
        options = {
            username: @username,
            password: @password,
            developer_token: @developer_token,
            customer_id: @customer_id,
            account_id: @account_id,
            wsdl_url: "https://campaign.api.sandbox.bingads.microsoft.com/Api/Advertiser/CampaignManagement/V10/CampaignManagementService.svc?singleWsdl",
            proxy: {
                logger: Logger.new(STDOUT),
                encoding: "UTF-8"
            }
        }
        client = BingAdsApi::ClientProxy.new(options)

        expect(client).not_to be_nil
        expect(client.service).not_to be_nil
    end

    it "should call service" do
        options = default_options.merge(
            wsdl_url: "https://campaign.api.sandbox.bingads.microsoft.com/Api/Advertiser/CampaignManagement/V10/CampaignManagementService.svc?singleWsdl"
        )

        client = BingAdsApi::ClientProxy.new(options)
        expect(client).not_to be_nil

        response = client.service.call(:get_campaigns_by_account_id,
            message: { account_id: client.account_id})
        expect(response).not_to be_nil
    end

    it "should create and call from config" do
        config = BingAdsApi::Config.instance
        options = default_options.merge(
            wsdl_url: config.service_wsdl(:sandbox, :campaign_management)
        )

        client = BingAdsApi::ClientProxy.new(options)
        expect(client).not_to be_nil

        response = client.service.call(:get_campaigns_by_account_id,
            message: { account_id: client.account_id})
        expect(response).not_to be_nil
    end

end
