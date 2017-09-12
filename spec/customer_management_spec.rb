# -*- encoding : utf-8 -*-
require 'spec_helper'

# Author:: jlopezn@neonline.cl
describe BingAdsApi::CustomerManagement do

    let(:default_options) do
        {
            environment: :sandbox,
            username: "ruby_bing_ads_sbx",
            password: "sandbox123",
            developer_token: "BBD37VB98",
            customer_id: "21025739",
            account_id: "8506945"
        }
    end
    let(:service) { BingAdsApi::CustomerManagement.new(default_options) }

    it "should initialize with options" do
        new_service = BingAdsApi::CustomerManagement.new(default_options)
        expect(new_service).not_to be_nil
    end

    it "should get accounts info" do
        response = service.get_accounts_info
        expect(response).not_to be_nil
        expect(response).to be_kind_of(Array)
    end

end
