# -*- encoding : utf-8 -*-
require 'spec_helper'

# Author:: jlopezn@neonline.cl
describe BingAdsApi::CampaignManagement do

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

	it "should initialize with options" do
		new_service = BingAdsApi::CampaignManagement.new(default_options)
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
				@campaign_id = BingAdsFactory.create_campaign
			end

			it "should get campaigns by account when there's only one campaign" do
				response = service.get_campaigns_by_account_id(default_options[:account_id])
				expect(response).not_to be_nil
				expect(response).to be_kind_of(Array)
			end

			it "should get campaigns by account when there are multiple campaigns" do
				BingAdsFactory.create_campaign
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

			it "should delete campaigns" do
				campaign_ids = [@campaign_id]

				response = service.delete_campaigns(default_options[:account_id], campaign_ids)

				expect(response).not_to be_nil
			end

		end
	end

	describe "ad group operations" do

		before :each do
			@campaign_id = BingAdsFactory.create_campaign
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

		context "when an ad group has already been created" do

			before :each do
			  @ad_group_id = BingAdsFactory.create_ad_group(@campaign_id)
			end

			it "should get ad groups by campaign when there's only one ad group" do
				response = service.get_ad_groups_by_campaign_id(@campaign_id)

				expect(response).not_to be_empty
				expect(response).to be_kind_of(Array)
			end

			it "should get ad groups by campaign when there are multiple ad groups" do
				BingAdsFactory.create_ad_group(@campaign_id)
				response = service.get_ad_groups_by_campaign_id(@campaign_id)

				expect(response).not_to be_empty
				expect(response).to be_kind_of(Array)
			end

			it "should get ad groups by ids when there's only one ad group" do
				response = service.get_ad_groups_by_ids(@campaign_id, [@ad_group_id])

				expect(response).not_to be_nil
				expect(response.size).to eq(1)
			end

			it "should get ad groups by ids when there are multiple ad groups" do
				ad_group_id_2 = BingAdsFactory.create_ad_group(@campaign_id)
				response = service.get_ad_groups_by_ids(@campaign_id, [@ad_group_id, ad_group_id_2])

				expect(response).not_to be_nil
				expect(response.size).to eq(2)
			end

			it "should update ad groups" do
				name = "Test Ad Group Update #{SecureRandom.uuid}"
				ad_groups = [
					BingAdsApi::AdGroup.new(
						id: @ad_group_id,
						name: name
					)
				]

				response = service.update_ad_groups(@campaign_id, ad_groups)
			end

		end
	end

	describe "ad operations" do

		before :each do
			campaign_id = BingAdsFactory.create_campaign
			@ad_group_id = BingAdsFactory.create_ad_group(campaign_id)
		end

		describe "text ads" do

			it "should add a single ad" do
				text_ad = BingAdsApi::TextAd.new(
					status: BingAdsApi::Ad::ACTIVE,
					destination_url: "http://www.adxion.com",
					display_url: "AdXion.com",
					text: "Text Ad #{SecureRandom.uuid}",
					title: "Text Ad"
				)

				response = service.add_ads(@ad_group_id, text_ad)
				expect(response).not_to be_nil
				expect(response[:partial_errors]).to be_nil
				expect(response[:ad_ids][:long]).not_to be_nil
			end

			it "should add multiple ads" do
				text_ads = [
					BingAdsApi::TextAd.new(
						status: BingAdsApi::Ad::ACTIVE,
						destination_url: "http://www.adxion.com",
						display_url: "AdXion.com",
						text: "TextAd #{SecureRandom.uuid}",
						title: "TextAd"
					),
					BingAdsApi::TextAd.new(
						status: BingAdsApi::Ad::ACTIVE,
						destination_url: "http://www.adxion.com",
						display_url: "AdXion.com",
						text: "TextAd 2 #{SecureRandom.uuid}",
						title: "TextAd 2"
					)
				]

				response = service.add_ads(@ad_group_id, text_ads)
				expect(response).not_to be_nil
				expect(response[:partial_errors]).to be_nil
				expect(response[:ad_ids][:long]).not_to be_nil
			end

		end

		describe "mobile ads" do

			it "should add a single ad" do
				mobile_ad = BingAdsApi::MobileAd.new(
					business_name: "Business",
					destination_url: "http://www.adxion.com",
					display_url: "adxion.com",
					phone_number: "555555555",
					text: "Publish with us",
					title: "Mobile Ad"
				)

				response = service.add_ads(@ad_group_id, mobile_ad)
				expect(response).not_to be_nil
				expect(response[:partial_errors]).to be_nil
				expect(response[:ad_ids][:long]).not_to be_nil
			end

			it "should add multiple ads" do
				mobile_ads = [
					BingAdsApi::MobileAd.new(
						business_name: "Business 1",
						destination_url: "http://www.adxion.com",
						display_url: "AdXion.com",
						phone_number: "555555555",
						text: "Publish with us",
						title: "MobileAd"
					),
					BingAdsApi::MobileAd.new(
						business_name: "Business 2",
						destination_url: "http://www.adxion.com",
						display_url: "AdXion.com",
						phone_number: "555555555",
						text: "Keep publishing",
						title: "MobileAd 2"
					)
				]

				response = service.add_ads(@ad_group_id, mobile_ads)
				expect(response).not_to be_nil
				expect(response[:partial_errors]).to be_nil
				expect(response[:ad_ids][:long]).not_to be_nil
			end

		end

		describe "product ads" do

			it "should add a single ad" do
				pending("Product ads not enabled for the test account")

				product_ad = BingAdsApi::ProductAd.new(
					promotional_text: "Promotion #{SecureRandom.uuid}"
				)

				response = service.add_ads(@ad_group_id, product_ad)
				expect(response).not_to be_nil
				expect(response[:partial_errors]).to be_nil
				expect(response[:ad_ids][:long]).not_to be_nil
			end

			it "should add multiple ads" do
				pending("Product ads not enabled for the test account")

				product_ads = [
					BingAdsApi::MobileAd.new(
						promotional_text: "My Promotional text #{SecureRandom.uuid}"
					),
					BingAdsApi::MobileAd.new(
						promotional_text: "My Promotional text 2 #{SecureRandom.uuid}"
					)
				]

				response = service.add_ads(@ad_group_id, product_ads)
				expect(response).not_to be_nil
			end

		end

		it "should add an ad with partial errors" do
			text_ad = BingAdsApi::TextAd.new(
				status: BingAdsApi::Ad::INACTIVE,
				destination_url: "http://www.adxion.com",
				display_url: "http://www.adxion.com",
				text: "Text Ad #{SecureRandom.uuid}",
				title: "Text Ad #{SecureRandom.uuid}"
			)

			response = service.add_ads(@ad_group_id, text_ad)
			expect(response).not_to be_nil
			expect(response[:partial_errors]).not_to be_nil
		end

		context "when an ad has already been created" do

			before :each do
			  @ad_id = BingAdsFactory.create_text_ad(@ad_group_id)
			end

			it "should get ads by ad group id when there's only one ad" do
				ads = service.get_ads_by_ad_group_id(@ad_group_id)
				expect(ads).not_to be_empty
				ad = ads.first
				expect(ad).to be_kind_of(BingAdsApi::Ad)
			end

			it "should get ads by ad group id when there are multiple ads" do
				BingAdsFactory.create_text_ad(@ad_group_id)
				ads = service.get_ads_by_ad_group_id(@ad_group_id)
				expect(ads).not_to be_empty
				ads.each do |ad|
					expect(ad).to be_kind_of(BingAdsApi::Ad)
				end
			end

			it "should get ads by ids when there's only one ad" do
				ads_by_ids = service.get_ads_by_ids(@ad_group_id, [@ad_id])
				expect(ads_by_ids).not_to be_nil
				expect(ads_by_ids.size).to eq(1)
			end

			it "should get ads by ids when there are multiple ads" do
				ad_id_2 = BingAdsFactory.create_text_ad(@ad_group_id)
				ads_by_ids = service.get_ads_by_ids(@ad_group_id, [@ad_id, ad_id_2])
				expect(ads_by_ids).not_to be_nil
				expect(ads_by_ids.size).to eq(2)
				ads_by_ids.each do |ad|
					expect(ad).to be_kind_of(BingAdsApi::Ad)
				end
			end

			it "should update ads" do
				text_ad = BingAdsApi::TextAd.new(
					id: @ad_id,
					status: BingAdsApi::Ad::ACTIVE,
					destination_url: "http://www.adxion.com",
					display_url: "http://www.adxion.com",
					text: "Ad #{SecureRandom.uuid}",
					title: "Title"
				)

				response = service.update_ads(@ad_group_id, [text_ad])
				expect(response).not_to be_nil
				expect(response[:partial_errors]).to be_nil
			end

		end
	end
end
