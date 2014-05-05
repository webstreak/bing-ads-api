require 'spec_helper'

describe BingAdsApi::Helpers::FilterHelper do
  include BingAdsApi::Helpers::FilterHelper

  let(:permitted_filters) {
    {
      "ad_distribution" => "AdDistribution",
      "device_os" => "DeviceOS",
      "device_type" => "DeviceType",
      "status" => "Status"
    }
  }

  it "should return true for valid filters" do
    expect(
      valid_filter(permitted_filters,
        {
          # String as bing expected
          :ad_distribution => "Search",
          :device_os => "Windows",
          # snake case symbol
          :device_type => :computer,
          # nil criteria
          :status => nil
        }
      )
    ).to be_true
  end

  it "should raise exception when invalid filter is provided" do
    expect{
      valid_filter(permitted_filters,
        {
          # Wrong String as bing expected
          :ad_distribution => "Searched",
          :device_os => "Windows",
          # snake case symbol
          :device_type => :computer,
          # nil criteria
          :status => nil
        }
      )
    }.to raise_error

    expect{
      valid_filter(permitted_filters,
        {
          # Wrong String as bing expected
          :ad_distribution => "Search",
          :device_os => "Windows",
          # Wrong snake case symbol
          :device_type => :notebook,
          # nil criteria
          :status => nil
        }
      )
    }.to raise_error
  end

  it "should raise exception when a bad key is provided" do
    expect{
      valid_filter(permitted_filters,
        {
          # Wrong filter criteria. ie: invalid key
          :not_a_valid_criteria => "Bleh",
        }
      )
    }.to raise_error
  end

end
