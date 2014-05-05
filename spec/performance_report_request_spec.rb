require 'spec_helper'

describe BingAdsApi::PerformanceReportRequest do
  describe "#initialize" do

    it "should initialize when valid parameters are provided" do
      expect{
        performance_report_request = BingAdsApi::PerformanceReportRequest.new(:format => :xml,
          :language => :english, :report_name => "My Report",
          :aggregation => :hourly, :time => :today)
      }.not_to raise_error
    end

    it "should raise an exception when an invalid aggregation is provided" do
      expect{
        performance_report_request = BingAdsApi::PerformanceReportRequest.new(:format => :xml,
          :language => :english, :report_name => "My Report",
          :aggregation => :invalid_aggregation)
      }.to raise_error
    end

    it "should raise an exception when an invalid time is provided" do
      expect{
        performance_report_request = BingAdsApi::PerformanceReportRequest.new(:format => :xml,
          :language => :english, :report_name => "My Report",
          :aggregation => :hourly, :time => :invalid_time)
      }.to raise_error
    end

  end
end
