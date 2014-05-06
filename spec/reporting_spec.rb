# -*- encoding : utf-8 -*-
require 'spec_helper'

# Author:: jlopezn@neonline.cl
describe BingAdsApi::Reporting do

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

	# Helper method to create a campaign on the remote API. Returns the created
	# campaign id.
	def create_campaign
		name = "Test Campaign #{SecureRandom.uuid}"
		campaigns = [
			BingAdsApi::Campaign.new(
				budget_type: BingAdsApi::Campaign::DAILY_BUDGET_STANDARD,
				daily_budget: 2000,
				daylight_saving: "false",
				description: name + " description",
				name: name + " name",
				time_zone: BingAdsApi::Campaign::SANTIAGO
			)
		]
		management_service = BingAdsApi::CampaignManagement.new(default_options)
		response = management_service.add_campaigns(default_options[:account_id], campaigns)
		response[:campaign_ids][:long]
	end

	it "should initialize with options" do
		new_service = BingAdsApi::Reporting.new(default_options)
		expect(new_service).not_to be_nil
	end

	it "should submit campaign performance report" do
		campaign_id = create_campaign
		report_request = BingAdsApi::CampaignPerformanceReportRequest.new(
			:format => :xml,
			:language => :english,
			:report_name => "My Report",
			:aggregation => :hourly,
			:columns => [
				:account_name, :account_number, :time_period,
				:campaign_name, :campaign_id, :status, :currency_code,
				:impressions, :clicks, :ctr, :average_cpc, :spend,
				:conversions, :conversion_rate, :cost_per_conversion, :average_cpm
			],
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
				:account_ids => default_options[:account_id],
				:campaigns => [
					{:account_id => default_options[:account_id], :campaign_id => campaign_id}
				]
			},
			:time => {
				:custom_date_range_end => {:day => 31, :month => 12, :year => 2013},
				:custom_date_range_start => {:day => 1, :month => 12, :year => 2013},
			}
		)

		report_request_id = nil
		expect{
			report_request_id = service.submit_generate_report(report_request)
		}.not_to raise_error

		expect(report_request_id).not_to be_nil
	end

	it "should submit account performance report" do
		report_request = BingAdsApi::AccountPerformanceReportRequest.new(
			:format => :xml,
			:language => :english,
			:report_name => "My Report",
			:aggregation => :hourly,
			:columns => [
				:account_name, :account_number, :time_period,
				:currency_code, :impressions, :clicks, :ctr, :average_cpc, :spend,
				:conversions, :cost_per_conversion, :average_cpm
			],
			:filter => {
				# String as bing expected
				:ad_distribution => "Search",
				# snake case symbol
				:device_os => :windows,
				# nil criteria
				:device_type => nil
			},
			:scope => {:account_ids => default_options[:account_id] },
			:time => {
				:custom_date_range_end => {:day => 31, :month => 12, :year => 2013},
				:custom_date_range_start => {:day => 1, :month => 12, :year => 2013},
			}
		)

		report_request_id = nil
		expect{
			report_request_id = service.submit_generate_report(report_request)
		}.not_to raise_error

		expect(report_request_id).not_to be_nil
	end

	it "should initialize report request status" do
		report_request_status = BingAdsApi::ReportRequestStatus.new(
			:report_download_url => "http://some.url.com",
			:status => "Success"
		)
		expect(report_request_status).not_to be_nil
	end

	context "when a report has been requested" do

		before :each do
			report_request = BingAdsApi::AccountPerformanceReportRequest.new(
				:format => :xml,
				:language => :english,
				:report_name => "My Report",
				:aggregation => :hourly,
				:columns => [
					:account_name, :account_number, :time_period,
					:currency_code, :impressions, :clicks, :ctr, :average_cpc, :spend,
					:conversions, :cost_per_conversion, :average_cpm
				],
				:filter => {
					# String as bing expected
					:ad_distribution => "Search",
					# snake case symbol
					:device_os => :windows,
					# nil criteria
					:device_type => nil
				},
				:scope => {:account_ids => default_options[:account_id] },
				:time => {
					:custom_date_range_end => {:day => 31, :month => 12, :year => 2013},
					:custom_date_range_start => {:day => 1, :month => 12, :year => 2013},
				}
			)

			@report_request_id = service.submit_generate_report(report_request)
		end

		it "should successfully poll generate report" do
			report_request_status = nil
			expect{
				report_request_status = service.poll_generate_report(@report_request_id)
			}.not_to raise_error

			expect(report_request_status).not_to be_nil

			expect(report_request_status.error?).to be_false
		end

	end
end
