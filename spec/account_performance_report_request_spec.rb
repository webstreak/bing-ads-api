require 'spec_helper'

describe BingAdsApi::AccountPerformanceReportRequest do
  it "initialize account performance report request" do
    expect{
      performance_report_request = BingAdsApi::AccountPerformanceReportRequest.new(:format => :xml,
        :language => :english, :report_name => "My Report",
        :aggregation => :hourly,
        :columns => [:account_name, :account_number, :time_period ],
        :filter => {
          # String as bing expected
          :ad_distribution => "Search",
          # snake case symbol
          :device_os => :windows,
          # no specified value
          :device_type => nil
        },
        :scope => {:account_ids => 12345},
        :time => :today )

      performance_report_request = BingAdsApi::AccountPerformanceReportRequest.new(:format => :xml,
        :language => :english, :report_name => "My Report",
        :aggregation => :hourly,
        :columns => [:account_name, :account_number, :time_period ],
        :filter => {
          # String as bing expected
          :ad_distribution => "Search",
          # snake case symbol
          :device_os => :windows,
          # no specified value
          :device_type => nil
        },
        :scope => {:account_ids => 12345},
        :time => {
          :custom_date_range_start => {
            :day => 1,
            :month => 12,
            :year => 2013
          },
          :custom_date_range_end => {
            :day => 31,
            :month => 12,
            :year => 2013
          }
        })
    }.not_to raise_error
  end
end
