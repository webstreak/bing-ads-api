# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'bing-ads-api/config'
require 'bing-ads-api/service/reporting'
require 'bing-ads-api/data/reporting/campaign_performance_report_request'
require 'bing-ads-api/data/reporting/account_performance_report_request'

# Author:: jlopezn@neonline.cl
describe BingAdsApi::Reporting do

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
		@service = BingAdsApi::Reporting.new(@options)
	end

	it "truth" do
		expect(BingAdsApi).to be_kind_of(Module)
	end

	it "initialize" do
		@service = BingAdsApi::Reporting.new(@options)
		expect(@service).not_to be_nil
	end


	it "should submit campaign performance report" do
		report_request = BingAdsApi::CampaignPerformanceReportRequest.new(:format => :xml,
			:language => :english,
			:report_name => "My Report",
			:aggregation => :hourly,
			:columns => [:account_name, :account_number, :time_period,
				:campaign_name, :campaign_id, :status, :currency_code,
				:impressions, :clicks, :ctr, :average_cpc, :spend,
				:conversions, :conversion_rate, :cost_per_conversion, :average_cpm ],
			:filter => {
				# String as bing expected
				:ad_distribution => "Search",
				:device_os => "Windows",
				# snake case symbol
				:device_type => :computer,
				# nil criteria
				:status => nil
			},
			:scope => {:account_ids => 5978083,
				:campaigns => [
					{:account_id => 5978083, :campaign_id => 1951230156},
					{:account_id => 5978083, :campaign_id => 1951245412},
					{:account_id => 5978083, :campaign_id => 1951245474}]
			},
			:time => {
				:custom_date_range_end => {:day => 31, :month => 12, :year => 2013},
				:custom_date_range_start => {:day => 1, :month => 12, :year => 2013},
			})

		report_request_id = nil
		expect{
			report_request_id = @service.submit_generate_report(report_request)
		}.not_to raise_error

		expect(report_request_id).not_to be_nil
	end


	it "should submit account performance report" do

		report_request = BingAdsApi::AccountPerformanceReportRequest.new(:format => :xml,
			:language => :english,
			:report_name => "My Report",
			:aggregation => :hourly,
			:columns => [:account_name, :account_number, :time_period,
				:currency_code, :impressions, :clicks, :ctr, :average_cpc, :spend,
				:conversions, :cost_per_conversion, :average_cpm ],
			:filter => {
				# String as bing expected
				:ad_distribution => "Search",
				# snake case symbol
				:device_os => :windows,
				# nil criteria
				:device_type => nil
			},
			:scope => {:account_ids => 5978083 },
			:time => {
				:custom_date_range_end => {:day => 31, :month => 12, :year => 2013},
				:custom_date_range_start => {:day => 1, :month => 12, :year => 2013},
			})

		report_request_id = nil
		expect{
			report_request_id = @service.submit_generate_report(report_request)
		}.not_to raise_error

		expect(report_request_id).not_to be_nil

	end


	it "initialize report request status" do
		report_request_status = BingAdsApi::ReportRequestStatus.new(:report_download_url => "http://some.url.com",
			:status => "Success")
		expect(report_request_status).not_to be_nil
	end


	it "should poll generate report" do
		report_request_id = 21265212
		report_request_status = nil
		expect{
			report_request_status = @service.poll_generate_report(report_request_id)
		}.not_to raise_error

		expect(report_request_status).not_to be_nil

		expect(report_request_status.error?).to be_true
	end


	it "should not poll generate report" do
		report_request_id = 5555555
		report_request_status = nil
		expect{
			report_request_status = @service.poll_generate_report(report_request_id)
		}.not_to raise_error

		expect(report_request_status.error?).to be_false
	end

end
