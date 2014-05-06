require 'spec_helper'

describe BingAdsApi::Config do

  let(:config) { BingAdsApi::Config.instance }

  it "should load" do
    expect(config).not_to be_nil
    expect(config.config).not_to be_nil
  end

  it "should load config constants" do
    expect(config.common_constants).not_to be_nil
    expect(config.campaign_management_constants).not_to be_nil
    expect(config.reporting_constants).not_to be_nil
  end

  it "should load config common constants" do
    expect(config.common_constants['time_zones']).not_to be_nil
    expect(config.common_constants['time_zones']['santiago']).not_to be_nil
  end

  it "should load config campaign management orders" do
    expect(config.campaign_management_orders['ad']).not_to be_nil
  end

  it "should get sandbox wsdl" do
    expect(config.service_wsdl(:sandbox, :campaign_management)).not_to be_nil
    expect(config.service_wsdl(:sandbox, :reporting)).not_to be_nil
  end

  it "should get production wsdl" do
    expect(config.service_wsdl(:production, :campaign_management)).not_to be_nil
    expect(config.service_wsdl(:production, :reporting)).not_to be_nil
  end

end
