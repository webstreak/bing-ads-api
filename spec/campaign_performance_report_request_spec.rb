require 'spec_helper'

describe BingAdsApi::CampaignPerformanceReportRequest
  it "should initialize campaign performance report request" do
    expect{
      performance_report_request = BingAdsApi::CampaignPerformanceReportRequest.new(:format => :xml,
        :language => :english, :report_name => "My Report",
        :aggregation => :hourly, :time => :today,
        :columns => [:account_name, :account_number, :time_period],
        :filter => {
          # String as bing expected
          :ad_distribution => "Search",
          :device_os => "Windows",
          # snake case symbol
          :device_type => :computer,
          # nil criteria
          :status => nil
        },
        :scope => {
          :account_ids => 12345,
          :campaigns => [
            {:account_id => 1234, :campaign_id => 1234},
            {:account_id => 1234, :campaign_id => 1234},
            {:account_id => 1234, :campaign_id => 1234}
          ]
        }
      )
    }.not_to raise_error
  end

  it "should raise an exception if the scope is invalid" do
    expect{
      performance_report_request = BingAdsApi::CampaignPerformanceReportRequest.new(:format => :xml,
        :language => :english, :report_name => "My Report",
        :aggregation => :hourly, :time => :today,
        :columns => [:account_name, :account_number, :time_period ],
        :scope => { :campaigns => []})
    }.to raise_error

    expect{
      performance_report_request = BingAdsApi::CampaignPerformanceReportRequest.new(:format => :xml,
        :language => :english, :report_name => "My Report",
        :aggregation => :hourly, :time => :today,
        :columns => [:account_name, :account_number, :time_period ],
        :scope => {:account_ids => 12345 })
    }.to raise_error
  end

  it "campaign performance filter " do
    expect{
      performance_report_request = BingAdsApi::CampaignPerformanceReportRequest.new(:format => :xml,
        :language => :english, :report_name => "My Report",
        :aggregation => :hourly, :time => :today,
        :columns => [:account_name, :account_number, :time_period ],
        :filter => {
          # String as bing expected
          :ad_distribution => "Search",
          :device_os => "Windows",
          # snake case symbol
          :device_type => :computer,
          # nil criteria
          :status => nil
        },
        :scope => {:account_ids => 12345,
        :campaigns => []})
    }.not_to raise_error
  end

  it "should raise campaign performance filter exception " do
    expect{
      performance_report_request = BingAdsApi::CampaignPerformanceReportRequest.new(:format => :xml,
        :language => :english, :report_name => "My Report",
        :aggregation => :hourly, :time => :today,
        :columns => [:account_name, :account_number, :time_period ],
        :filter => {
          # Wrong String as bing expected
          :ad_distribution => "Searched",
          :device_os => "Windows",
          # snake case symbol
          :device_type => :computer,
          # nil criteria
          :status => nil
        },
        :scope => {:account_ids => 12345,
        :campaigns => []})
    }.to raise_error

    expect{
      performance_report_request = BingAdsApi::CampaignPerformanceReportRequest.new(:format => :xml,
        :language => :english, :report_name => "My Report",
        :aggregation => :hourly, :time => :today,
        :columns => [:account_name, :account_number, :time_period ],
        :filter => {
          # Wrong String as bing expected
          :ad_distribution => "Search",
          :device_os => "Windows",
          # Wrong snake case symbol
          :device_type => :notebook,
          # nil criteria
          :status => nil
        },
        :scope => {:account_ids => 12345,
        :campaigns => []})
    }.to raise_error

    expect{
      performance_report_request = BingAdsApi::CampaignPerformanceReportRequest.new(:format => :xml,
        :language => :english, :report_name => "My Report",
        :aggregation => :hourly, :time => :today,
        :columns => [:account_name, :account_number, :time_period ],
        :filter => {
          # Wrong filter criteria. ie: invalid key
          :not_a_valid_criteria => "Bleh",
        },
        :scope => {:account_ids => 12345,
        :campaigns => []})
    }.to raise_error
  end

end
