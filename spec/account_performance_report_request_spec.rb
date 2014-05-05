require 'spec_helper'

describe BingAdsApi::AccountPerformanceReportRequest do
  it "initialize account performance report request" do
    expect{
      BingAdsApi::AccountPerformanceReportRequest.new(
        :format => :xml, :language => :english, :report_name => "My Report",
        :aggregation => :hourly,
        :columns => [:account_name, :account_number, :time_period],
        :filter => {
          # String as bing expected
          :ad_distribution => "Search",
          # snake case symbol
          :device_os => :windows,
          # no specified value
          :device_type => nil
        },
        :scope => {:account_ids => 12345},
        :time => :today
      )
    }.not_to raise_error
  end

  it "should raise an exception if the scope is invalid" do
    expect{
      BingAdsApi::AccountPerformanceReportRequest.new(
        :format => :xml, :language => :english, :report_name => "My Report",
        :aggregation => :hourly,
        :columns => [:account_name, :account_number, :time_period],
        :filter => {
          # String as bing expected
          :ad_distribution => "Search",
          # snake case symbol
          :device_os => :windows,
          # no specified value
          :device_type => nil
        },
        :scope => {},
        :time => :today
      )
    }.to raise_error
  end
end
