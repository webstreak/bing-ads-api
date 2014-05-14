# -*- encoding : utf-8 -*-
require 'spec_helper'

# Author:: alex.cavalli@offers.com
describe BingAdsApi::Bulk do

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
	let(:service) { BingAdsApi::Bulk.new(default_options) }

	it "should initialize with options" do
		new_service = BingAdsApi::Bulk.new(default_options)
		expect(new_service).not_to be_nil
	end

	it "should download campaigns by account id" do
		campaign_id = BingAdsFactory.create_campaign
		account_ids = [default_options[:account_id]]
		entities = [:campaigns, :ad_groups, :keywords, :ads]
		options = {
	    data_scope: :entity_performance_data,
	    download_file_type: :csv,
	    format_version: 2.0,
	    last_sync_time_in_utc: "2001-10-26T21:32:52",
	    location_target_version: "Latest",
	    performance_stats_date_range: {
	  		custom_date_range_end:   {day: 31, month: 12, year: 2013},
	  		custom_date_range_start: {day: 1, month: 12, year: 2013}
	  	}
		}

		download_request_id = nil
		expect{
			download_request_id = service.download_campaigns_by_account_ids(
				account_ids,
				entities,
				options
			)
		}.not_to raise_error

		expect(download_request_id).not_to be_nil
	end

	context "when a bulk request has been requested" do

		before :each do
			BingAdsFactory.create_campaign
			@download_request_id = service.download_campaigns_by_account_ids(
				[default_options[:account_id]],
				[:campaigns, :ad_groups, :keywords, :ads]
			)
		end

		it "should successfully get detailed response status" do
			bulk_download_status = nil
			expect{
				bulk_download_status = service.get_detailed_bulk_download_status(@download_request_id)
			}.not_to raise_error

			expect(bulk_download_status).not_to be_nil

			expect(bulk_download_status.error?).to be_false
		end

	end
end
