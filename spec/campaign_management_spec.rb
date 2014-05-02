# -*- encoding : utf-8 -*-
require 'spec_helper'

# Author:: jlopezn@neonline.cl
describe BingAdsApi::CampaignManagement do

	let(:config) { BingAdsApi::Config.instance }
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
	let(:service) { BingAdsApi::CampaignManagement.new(default_options) }

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
		response = service.add_campaigns(default_options[:account_id], campaigns)
		response[:campaign_ids][:long]
	end

	def create_ad_group(campaign_id)
		name = "Ad Group #{SecureRandom.uuid}"
		ad_groups = [
			BingAdsApi::AdGroup.new(
				ad_distribution: BingAdsApi::AdGroup::SEARCH,
				language: BingAdsApi::AdGroup::SPANISH,
				name: name + " name",
				pricing_model: BingAdsApi::AdGroup::CPC,
				bidding_model: BingAdsApi::AdGroup::KEYWORD
			)
		]
		response = service.add_ad_groups(campaign_id, ad_groups)
		response[:ad_group_ids][:long]
	end

	it "should initialize with options" do
		new_service = BingAdsApi::CampaignManagement.new(options)
		expect(new_service).not_to be_nil
	end

	describe "campaign operations" do

		it "should add a campaign" do
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
			response = service.add_campaigns(default_options[:account_id], campaigns)

			expect(response[:campaign_ids][:long]).not_to be_nil
		end

		context "when a campaign has already been created" do

			before :each do
				@campaign_id = create_campaign
			end

			it "should get campaigns by account" do
				response = service.get_campaigns_by_account_id(default_options[:account_id])
				expect(response).not_to be_nil
				expect(response).to be_kind_of(Array)
			end

			it "should update campaigns" do
				name = "Test Campaign Update #{SecureRandom.uuid}"
				campaigns = [
					BingAdsApi::Campaign.new(
						id: @campaign_id,
						budget_type: BingAdsApi::Campaign::DAILY_BUDGET_STANDARD,
						daily_budget: 2000,
						daylight_saving: "false",
						description: name + " description",
						name: name + " name",
						time_zone: BingAdsApi::Campaign::SANTIAGO
					)
				]

				response = service.update_campaigns(default_options[:account_id], campaigns)

				expect(response).not_to be_nil
			end

		end

	end

	describe "ad group operations" do

		before :each do
			@campaign_id = create_campaign
		end

		it "should add an ad group" do
			name = "Ad Group #{SecureRandom.uuid}"
			ad_groups = [
				BingAdsApi::AdGroup.new(
					ad_distribution: BingAdsApi::AdGroup::SEARCH,
					language: BingAdsApi::AdGroup::SPANISH,
					name: name + " name",
					pricing_model: BingAdsApi::AdGroup::CPC,
					bidding_model: BingAdsApi::AdGroup::KEYWORD
				)
			]
			response = service.add_ad_groups(@campaign_id, ad_groups)

			expect(response[:ad_group_ids][:long]).not_to be_nil
		end

		context "ad group operations" do

			before :each do
			  @ad_group_id = create_ad_group(@campaign_id)
			end

			it "should get ad groups by campaign" do
				create_ad_group(@campaign_id)
				response = service.get_ad_groups_by_campaign_id(@campaign_id)

				expect(response).not_to be_empty
				expect(response).to be_kind_of(Array)
			end

			it "should get ad groups by campaign when there's only one ad group" do
				response = service.get_ad_groups_by_campaign_id(@campaign_id)

				expect(response).not_to be_empty
				expect(response).to be_kind_of(Array)
			end

			it "should get ad groups by ids" do
				response = service.get_ad_groups_by_ids(@campaign_id, [@ad_group_id])

				expect(response).not_to be_nil
				expect(response.size).to eq(1)
			end

			it "should update ad groups" do
				name = "Test Ad Group Update #{SecureRandom.uuid}"
				ad_groups = [
					BingAdsApi::AdGroup.new(
						id: @ad_group_id,
						name: name + " updated name"
					)
				]

				response = service.update_ad_groups(@campaign_id, ad_groups)
			end

		end

	end

	describe "ad operations" do

		describe "text ads" do

			it "should add a single ad" do
				# NOPE need to manually create ad group in which to add ads
				ad_group_id = 1980939070

				date = DateTime.now.strftime("%Y-%m-%d %H:%M:%S")

				# TextAd
				text_ad = BingAdsApi::TextAd.new(
						type: BingAdsApi::Ad::TEXT,
						status: BingAdsApi::Ad::INACTIVE,
						destination_url: "http://www.adxion.com",
						display_url: "AdXion.com",
						text: "Text Ad #{date}",
						title: "Text Ad")

				response = service.add_ads(ad_group_id, text_ad)
				expect(response).not_to be_nil

				expect(response[:partial_errors]).not_to be_nil

				expect(response[:ad_ids][:long]).not_to be_nil
			end

			it "should add multiple ads" do
				# NOPE need to manually create ad group in which to add ads
				ad_group_id = 1980939070

				date = DateTime.now.strftime("%Y-%m-%d %H:%M:%S")

				# TextAds
				text_ads = [
					BingAdsApi::TextAd.new(
						type: BingAdsApi::Ad::TEXT,
						status: BingAdsApi::Ad::INACTIVE,
						destination_url: "http://www.adxion.com",
						display_url: "AdXion.com",
						text: "TextAd #{date}",
						title: "TextAd"),

					BingAdsApi::TextAd.new(
						type: BingAdsApi::Ad::TEXT,
						status: BingAdsApi::Ad::INACTIVE,
						destination_url: "http://www.adxion.com",
						display_url: "AdXion.com",
						text: "TextAd 2 #{date}",
						title: "TextAd 2")
				]
				response = service.add_ads(ad_group_id, text_ads)
				expect(response).not_to be_nil

				expect(response[:partial_errors]).not_to be_nil

				expect(response[:ad_ids][:long]).not_to be_nil
			end

		end

		describe "mobile ads" do

			it "should add a single ad" do
				# NOPE need to manually create ad group in which to add ads
				ad_group_id = 1980939070

				date = DateTime.now.strftime("%Y-%m-%d %H:%M:%S")

				# MobileAd
				mobile_ad = BingAdsApi::MobileAd.new(
						bussines_name: "Bussiness",
						destination_url: "http://www.adxion.com",
						display_url: "adxion.com",
						phone_number: "555555555",
						text: "Publish with us",
						title: "Mobile Ad")

				response = service.add_ads(ad_group_id, mobile_ad)
				expect(response).not_to be_nil

				expect(response[:partial_errors]).not_to be_nil

				expect(response[:ad_ids][:long]).not_to be_nil
			end

			it "should add multiple ads" do
				# NOPE need to manually create ad group in which to add ads
				ad_group_id = 1980939070

				date = DateTime.now.strftime("%Y-%m-%d %H:%M:%S")

				mobile_ads = [
					BingAdsApi::MobileAd.new(
						bussines_name: "Bussiness 1",
						destination_url: "http://www.adxion.com",
						display_url: "AdXion.com",
						phone_number: "555555555",
						text: "Publish with us",
						title: "MobileAd"),

					BingAdsApi::MobileAd.new(
						bussines_name: "Bussiness 2",
						destination_url: "http://www.adxion.com",
						display_url: "AdXion.com",
						phone_number: "555555555",
						text: "Keep publishing",
						title: "MobileAd 2")
				]
				response = service.add_ads(ad_group_id, mobile_ads)
				expect(response).not_to be_nil

				expect(response[:partial_errors]).not_to be_nil

				expect(response[:ad_ids][:long]).not_to be_nil
			end

		end

		describe "product ads" do

			it "should add a single ad" do
				# NOPE need to manually create ad group in which to add ads
				ad_group_id = 1980939070

				date = DateTime.now.strftime("%Y-%m-%d %H:%M:%S")

				# ProductAd
				product_ad = BingAdsApi::ProductAd.new(
						promotional_text: "Promotion #{date}")
				response = service.add_ads(ad_group_id, product_ad)
				expect(response).not_to be_nil

				expect(response[:partial_errors]).not_to be_nil

				expect(response[:ad_ids][:long]).not_to be_nil
			end

			it "should add multiple ads" do
				# NOPE need to manually create ad group in which to add ads
				ad_group_id = 1980939070

				date = DateTime.now.strftime("%Y-%m-%d %H:%M:%S")

				product_ads = [
					BingAdsApi::MobileAd.new(
						promotional_text: "My Promotional text #{date}"),

					BingAdsApi::MobileAd.new(
						promotional_text: "My Promotional text 2 #{date}")
				]
				response = service.add_ads(ad_group_id, product_ads)
				expect(response).not_to be_nil
			end

		end

		it "should add an ad with partial errors" do
			# NOPE need to manually create ad group in which to add ads
			ad_group_id = 1980939070

			date = DateTime.now.strftime("%Y-%m-%d %H:%M:%S")
			text_ad = BingAdsApi::TextAd.new(
					type: BingAdsApi::Ad::TEXT,
					status: BingAdsApi::Ad::INACTIVE,
					destination_url: "http://www.adxion.com",
					display_url: "http://www.adxion.com",
					text: "it Text Ad #{date}",
					title: "it Text Ad #{date}")

			response = service.add_ads(ad_group_id, text_ad)
			expect(response).not_to be_nil

			expect(response[:partial_errors]).not_to be_nil
		end

		it "should get ads by group id" do
			# need to manually create ads in an ad group and pull them
			campaigns = service.get_campaigns_by_account_id(default_options[:account_id])
			expect(campaigns).not_to be_empty
			campaign_id = campaigns.first.id

			ad_group = service.get_ad_groups_by_campaign_id(campaign_id).first

			ads = service.get_ads_by_ad_group_id(ad_group.id)
			expect(ads).not_to be_empty
			ads.each do |ad|
				expect(ad).to be_kind_of(BingAdsApi::Ad)
			end
		end

		it "should get ads by ids" do
			# need to manually create ads
			ad_group_id = 1980939070
			ads = service.get_ads_by_ad_group_id(ad_group_id)
			expect(ads).not_to be_nil
			expect(ads).not_to be_empty

			# Get 2 ads
			ad_ids = [ads[0].id, ads[1].id]
			ads_by_ids = service.get_ads_by_ids(ad_group_id, ad_ids)
			expect(ads_by_ids).not_to be_nil
			expect(ads_by_ids).not_to be_empty
			expect(ad_ids.size).to eq(ads_by_ids.size)
			ads.each do |ad|
				expect(ad).to be_kind_of(BingAdsApi::Ad)
			end

			# Get specific ad
			ad_ids = [ads[0].id]
			ads_by_ids = service.get_ads_by_ids(ad_group_id, ad_ids)
			expect(ads_by_ids).not_to be_nil
			expect(ads).not_to be_empty
			expect(ad_ids.size).to eq(ads_by_ids.size)
		end

		it "should update ads" do
			# need to manually create ads
			ad_group_id = 1980939070
			# One TextAd and one MobileAd
			ad_ids = [4560003693, 4560003694]

			ads = service.get_ads_by_ids(ad_group_id, ad_ids)

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

			response = service.update_ads(ad_group_id, ads)
			expect(response).not_to be_nil

			expect(response[:partial_errors]).not_to be_nil
		end
	end

end
