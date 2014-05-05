# -*- encoding : utf-8 -*-
require 'spec_helper'

# Author:: jlopezn@neonline.cl
describe BingAdsApi::ReportRequest do

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
	let(:service) { BingAdsApi::Reporting.new(default_options) }

	describe "#initialize" do
		it "should initialize when valid parameters are provided" do
			expect{
				report_request = BingAdsApi::ReportRequest.new(:format => :xml,
					:language => :english, :report_name => "My Report",
					:return_only_complete_data => true)
			}.not_to raise_error
		end

		it "should raise an exception when an invalid format is provided" do
			expect{
				report_request = BingAdsApi::ReportRequest.new(:format => :invalid,
					:language => :english, :report_name => "My Report",
					:return_only_complete_data => true)
			}.to raise_error
		end

		it "should raise an exception when an invalid language is provided" do
			expect{
				report_request = BingAdsApi::ReportRequest.new(:format => :xml,
					:language => :swahili, :report_name => "My Report",
					:return_only_complete_data => true)
			}.to raise_error
		end
	end

	it "initialize performance report request" do
		expect{
			performance_report_request = BingAdsApi::PerformanceReportRequest.new(:format => :xml,
				:language => :english, :report_name => "My Report",
				:aggregation => :hourly, :time => :today)
		}.not_to raise_error
	end

  it "should raise aggregation exception" do
		expect{
			performance_report_request = BingAdsApi::PerformanceReportRequest.new(:format => :xml,
				:language => :english, :report_name => "My Report",
				:aggregation => :invalid_aggregation)
		}.to raise_error
	end

	it "should raise time exception" do
		expect{
			performance_report_request = BingAdsApi::PerformanceReportRequest.new(:format => :xml,
				:language => :english, :report_name => "My Report",
				:aggregation => :weekly)
		}.to raise_error
	end

	it "initialize campaign performance report request" do
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
				:campaigns => [
					{:account_id => 1234, :campaign_id => 1234},
					{:account_id => 1234, :campaign_id => 1234},
					{:account_id => 1234, :campaign_id => 1234}]
				})

			performance_report_request = BingAdsApi::CampaignPerformanceReportRequest.new(:format => :xml,
				:language => :english, :report_name => "My Report",
				:aggregation => :hourly,
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
				},
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

	it "should raise column exception " do
		expect{
			performance_report_request = BingAdsApi::CampaignPerformanceReportRequest.new(:format => :xml,
				:language => :english, :report_name => "My Report",
				:aggregation => :hourly, :time => :today,
				:columns => [:account_name, :account_number, :time_period, :unknown_column ],
				:scope => {:account_ids => 12345,
				:campaigns => []})
		}.to raise_error

		expect{
			performance_report_request = BingAdsApi::CampaignPerformanceReportRequest.new(:format => :xml,
				:language => :english, :report_name => "My Report",
				:aggregation => :hourly, :time => :today,
				:columns => [:account_name, :account_number, :time_period, "UnknownColumn" ],
				:scope => {:account_ids => 12345,
				:campaigns => []})
		}.to raise_error
	end

	it "should raise scope exception " do
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
