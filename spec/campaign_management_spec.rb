# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'bing-ads-api/config'
require 'bing-ads-api/service/campaign_management'

# Author:: jlopezn@neonline.cl
describe BingAdsApi::CampaignManagement do

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
		@service = BingAdsApi::CampaignManagement.new(@options)
	end

	it "truth" do
		expect(BingAdsApi).to be_kind_of(Module)
	end

	it "initialize" do
		@service = BingAdsApi::CampaignManagement.new(@options)
		expect(@service).not_to be_nil
	end

	it "get campaigns by account" do
		response = @service.get_campaigns_by_account_id(@options[:account_id])
		expect(response).not_to be_nil
		expect(response).to be_kind_of(Array)
	end

	it "add campaign" do
		name = "it Campaign #{DateTime.now.strftime("%Y-%m-%d %H:%M:%S")}"
		campaigns = [
			BingAdsApi::Campaign.new(
			:budget_type => BingAdsApi::Campaign::DAILY_BUDGET_STANDARD,
			:conversion_tracking_enabled => "false",
			:daily_budget => 2000,
			:daylight_saving => "false",
			:description => name + " description",
			:monthly_budget => 5400,
			:name => name + " name",
			:status => BingAdsApi::Campaign::PAUSED,
			:time_zone => BingAdsApi::Campaign::SANTIAGO),
		]
		response = @service.add_campaigns(@options[:account_id], campaigns)

		expect(response[:campaign_ids][:long]).not_to be_nil
	end

	it "add campaigns" do
		name = "it Campaign #{DateTime.now.strftime("%Y-%m-%d %H:%M:%S")}"
		campaigns = [
			BingAdsApi::Campaign.new(
				:budget_type => BingAdsApi::Campaign::DAILY_BUDGET_STANDARD,
				:conversion_tracking_enabled => "false",
				:daily_budget => 2000,
				:daylight_saving => "false",
				:description => name + " first description",
				:monthly_budget => 5400,
				:name => name + " first name",
				:status => BingAdsApi::Campaign::PAUSED,
				:time_zone => BingAdsApi::Campaign::SANTIAGO),

			BingAdsApi::Campaign.new(
				:budget_type => BingAdsApi::Campaign::DAILY_BUDGET_STANDARD,
				:conversion_tracking_enabled => "false",
				:daily_budget => 2500,
				:daylight_saving => "false",
				:description => name + " second description",
				:monthly_budget => 7800,
				:name => name + " second name",
				:status => BingAdsApi::Campaign::PAUSED,
				:time_zone => BingAdsApi::Campaign::SANTIAGO),

		]
		response = @service.add_campaigns(@options[:account_id], campaigns)

		expect(response[:campaign_ids][:long]).not_to be_nil
		expect(response[:campaign_ids][:long]).to be_kind_of(Array)
		expect(response[:campaign_ids][:long].size).to eq(campaigns.size)
	end

	it "update campaigns" do
		campaigns = @service.get_campaigns_by_account_id(@options[:account_id])
		expect(campaigns).not_to be_nil

		campaigns.each do |campaign|
			campaign.description = campaign.description + " updated #{DateTime.now.strftime("%Y-%m-%d %H:%M:%S")}"
			campaign.status = nil
		end

		response = @service.update_campaigns(@options[:account_id], campaigns)

		expect(response).not_to be_nil
	end

	it "get ad groups by campaign" do
		campaigns = @service.get_campaigns_by_account_id(@options[:account_id])
		expect(campaigns).not_to be_empty
		campaign_id = campaigns.first.id

		response = @service.get_ad_groups_by_campaign_id(campaign_id)

		expect(response).not_to be_empty
		expect(response).to be_kind_of(Array)
	end

	it "get ad groups by ids" do
		campaigns = @service.get_campaigns_by_account_id(@options[:account_id])
		expect(campaigns).not_to be_empty
		campaign_id = campaigns.first.id

		groups = @service.get_ad_groups_by_campaign_id(campaign_id)

		ad_group_ids = groups.map{ |gr| gr.id }
		response = @service.get_ad_groups_by_ids(campaign_id, ad_group_ids)

		expect(response).not_to be_nil
		expect(response.size).to eq(ad_group_ids.size)
	end

	it "add ad group" do
		campaigns = @service.get_campaigns_by_account_id(@options[:account_id])
		expect(campaigns).not_to be_empty
		campaign_id = campaigns.first.id

		name = "Ad Group #{DateTime.now.strftime("%Y-%m-%d %H:%M:%S")}"
		ad_groups = [
			BingAdsApi::AdGroup.new(
			:ad_distribution => BingAdsApi::AdGroup::SEARCH,
			:language => BingAdsApi::AdGroup::SPANISH,
			:name => name + " name",
			:pricing_model => BingAdsApi::AdGroup::CPC,
			:bidding_model => BingAdsApi::AdGroup::KEYWORD)
		]
		response = @service.add_ad_groups(campaign_id, ad_groups)

		expect(response[:ad_group_ids][:long]).not_to be_nil
	end

	it "add ad groups" do
		campaigns = @service.get_campaigns_by_account_id(@options[:account_id])
		expect(campaigns).not_to be_empty
		campaign_id = campaigns.first.id

		name = "Ad Group #{DateTime.now.strftime("%Y-%m-%d %H:%M:%S")}"
		ad_groups = [
			BingAdsApi::AdGroup.new(
			:ad_distribution => BingAdsApi::AdGroup::SEARCH,
			:language => BingAdsApi::AdGroup::SPANISH,
			:name => name + " name",
			:pricing_model => BingAdsApi::AdGroup::CPC,
			:bidding_model => BingAdsApi::AdGroup::KEYWORD),

			BingAdsApi::AdGroup.new(
			:ad_distribution => BingAdsApi::AdGroup::SEARCH,
			:language => BingAdsApi::AdGroup::SPANISH,
			:name => name + " second name",
			:pricing_model => BingAdsApi::AdGroup::CPC,
			:bidding_model => BingAdsApi::AdGroup::KEYWORD)

		]
		response = @service.add_ad_groups(campaign_id, ad_groups)

		expect(response[:ad_group_ids][:long]).not_to be_nil
		expect(response[:ad_group_ids][:long]).to be_kind_of(Array)
		expect(response[:ad_group_ids][:long].size).to eq(ad_groups.size)
	end

	it "update ad groups" do
		campaigns = @service.get_campaigns_by_account_id(@options[:account_id])
		expect(campaigns).not_to be_empty
		campaign_id = campaigns.first.id

		ad_groups = @service.get_ad_groups_by_campaign_id(campaign_id)

		ad_groups_to_update = ad_groups.map do |ad_group|
			BingAdsApi::AdGroup.new(
				:id => ad_group.id,
				:name => ad_group.name + " updated #{DateTime.now.strftime("%Y-%m-%d %H:%M:%S")}" )
		end

		response = @service.update_ad_groups(campaign_id, ad_groups_to_update)

		expect(response).not_to be_nil
	end

	it "add ads" do
		ad_group_id = 1980939070

		date = DateTime.now.strftime("%Y-%m-%d %H:%M:%S")

		# TextAds
		text_ads = [
			BingAdsApi::TextAd.new(
				:type => BingAdsApi::Ad::TEXT,
				:status => BingAdsApi::Ad::INACTIVE,
				:destination_url => "http://www.adxion.com",
				:display_url => "AdXion.com",
				:text => "TextAd #{date}",
				:title => "TextAd"),

			BingAdsApi::TextAd.new(
				:type => BingAdsApi::Ad::TEXT,
				:status => BingAdsApi::Ad::INACTIVE,
				:destination_url => "http://www.adxion.com",
				:display_url => "AdXion.com",
				:text => "TextAd 2 #{date}",
				:title => "TextAd 2")
		]
		response = @service.add_ads(ad_group_id, text_ads)
		expect(response).not_to be_nil

		expect(response[:partial_errors]).not_to be_nil

		puts "Text: AddAds response[:ad_ids][:long]"
		puts response[:ad_ids][:long]
		expect(response[:ad_ids][:long]).not_to be_nil

		mobile_ads = [
			BingAdsApi::MobileAd.new(
				:bussines_name => "Bussiness 1",
				:destination_url => "http://www.adxion.com",
				:display_url => "AdXion.com",
				:phone_number => "555555555",
				:text => "Publish with us",
				:title => "MobileAd"),

			BingAdsApi::MobileAd.new(
				:bussines_name => "Bussiness 2",
				:destination_url => "http://www.adxion.com",
				:display_url => "AdXion.com",
				:phone_number => "555555555",
				:text => "Keep publishing",
				:title => "MobileAd 2")
		]
		response = @service.add_ads(ad_group_id, mobile_ads)
		expect(response).not_to be_nil

		puts response[:partial_errors] if !response[:partial_errors].nil?
		expect(response[:partial_errors]).not_to be_nil

		puts "Mobile: AddAds response[:ad_ids][:long]"
		puts response[:ad_ids][:long]
		expect(response[:ad_ids][:long]).not_to be_nil

		# product_ads = [
			# BingAdsApi::MobileAd.new(
				# :promotional_text => "My Promotional text #{date}"),
#
			# BingAdsApi::MobileAd.new(
				# :promotional_text => "My Promotional text 2 #{date}")
		# ]
		# response = @service.add_ads(ad_group_id, product_ads)
		# expect(response).not_to be_nil

	end

	it "add ad" do
		ad_group_id = 1980939070

		date = DateTime.now.strftime("%Y-%m-%d %H:%M:%S")

		# TextAd
		text_ad = BingAdsApi::TextAd.new(
				:type => BingAdsApi::Ad::TEXT,
				:status => BingAdsApi::Ad::INACTIVE,
				:destination_url => "http://www.adxion.com",
				:display_url => "AdXion.com",
				:text => "Text Ad #{date}",
				:title => "Text Ad")

		response = @service.add_ads(ad_group_id, text_ad)
		expect(response).not_to be_nil

		expect(response[:partial_errors]).not_to be_nil

		puts "Text: AddAds response[:ad_ids][:long]"
		puts response[:ad_ids][:long]
		expect(response[:ad_ids][:long]).not_to be_nil


		# MobileAd
		mobile_ad = BingAdsApi::MobileAd.new(
				:bussines_name => "Bussiness",
				:destination_url => "http://www.adxion.com",
				:display_url => "adxion.com",
				:phone_number => "555555555",
				:text => "Publish with us",
				:title => "Mobile Ad")

		response = @service.add_ads(ad_group_id, mobile_ad)
		expect(response).not_to be_nil

		puts response[:partial_errors] if !response[:partial_errors].nil?
		expect(response[:partial_errors]).not_to be_nil

		puts "Mobile: AddAds response[:ad_ids][:long]"
		puts response[:ad_ids][:long]
		expect(response[:ad_ids][:long]).not_to be_nil

		# ProductAd
		# product_ad = BingAdsApi::ProductAd.new(
				# :promotional_text => "Promotion #{date}")
		# response = @service.add_ads(ad_group_id, product_ad)
		# expect(response).not_to be_nil
#
		# puts response[:partial_errors] if !response[:partial_errors].nil?
		# expect(response[:partial_errors]).not_to be_nil
#
		# puts "Product: AddAds response[:ad_ids][:long]"
		# puts response[:ad_ids][:long]
		# expect(response[:ad_ids][:long]).not_to be_nil
	end

	it "add ad with partial errors" do
		ad_group_id = 1980939070

		date = DateTime.now.strftime("%Y-%m-%d %H:%M:%S")
		text_ad = BingAdsApi::TextAd.new(
				:type => BingAdsApi::Ad::TEXT,
				:status => BingAdsApi::Ad::INACTIVE,
				:destination_url => "http://www.adxion.com",
				:display_url => "http://www.adxion.com",
				:text => "it Text Ad #{date}",
				:title => "it Text Ad #{date}")

		response = @service.add_ads(ad_group_id, text_ad)
		expect(response).not_to be_nil

		puts response[:partial_errors]
		expect(response[:partial_errors]).not_to be_nil
	end

	it "get ads by group id" do
		campaigns = @service.get_campaigns_by_account_id(@options[:account_id])
		expect(campaigns).not_to be_empty
		campaign_id = campaigns.first.id

		ad_group = @service.get_ad_groups_by_campaign_id(campaign_id).first

		ads = @service.get_ads_by_ad_group_id(ad_group.id)
		expect(ads).not_to be_empty
		ads.each do |ad|
			expect(ad).to be_kind_of(BingAdsApi::Ad)
		end
	end

	it "get ads by ids" do
		# campaigns = @service.get_campaigns_by_account_id(@options[:account_id])
		# expect(campaigns).not_to be_empty
		# campaign_id = campaigns.first.id
		# ad_group = @service.get_ad_groups_by_campaign_id(campaign_id).first
		# ads = @service.get_ads_by_ad_group_id(ad_group.id)
		ad_group_id = 1980939070
		ads = @service.get_ads_by_ad_group_id(ad_group_id)
		expect(ads).not_to be_nil
		expect(ads).not_to be_empty

		# Get 2 ads
		ad_ids = [ads[0].id, ads[1].id]
		ads_by_ids = @service.get_ads_by_ids(ad_group_id, ad_ids)
		expect(ads_by_ids).not_to be_nil
		expect(ads_by_ids).not_to be_empty
		expect(ad_ids.size).to eq(ads_by_ids.size)
		ads.each do |ad|
			expect(ad).to be_kind_of(BingAdsApi::Ad)
		end

		# Get specific ad
		ad_ids = [ads[0].id]
		ads_by_ids = @service.get_ads_by_ids(ad_group_id, ad_ids)
		expect(ads_by_ids).not_to be_nil
		expect(ads).not_to be_empty
		expect(ad_ids.size).to eq(ads_by_ids.size)
	end

	it "update ads" do
		ad_group_id = 1980939070
		# One TextAd and one MobileAd
		ad_ids = [4560003693, 4560003694]

		ads = @service.get_ads_by_ids(ad_group_id, ad_ids)

		# Loop to modify something in the adds
		ads.each do |ad|
			case ad.type
			when "Text"
				ad.text = ad.text + " updated"
			when "Mobile"
				ad.phone_number = 1234567890
			when "Product"
				ad.promotional_text = ad.promotional_text + " edit"
			end
			ad.status = nil
			ad.editorial_status = nil
		end

		response = @service.update_ads(ad_group_id, ads)
		expect(response).not_to be_nil

		expect(response[:partial_errors]).not_to be_nil
	end


end
