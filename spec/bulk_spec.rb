# -*- encoding : utf-8 -*-
require 'spec_helper'
require 'tempfile'

# Author:: alex.cavalli@offers.com
describe BingAdsApi::Bulk do

    def generate_bulk_upload_file
        raise ArgumentError, "Block is required" unless block_given?
        Tempfile.open(["bulk_upload", ".csv"]) do |tempfile|
            tempfile.binmode
            tempfile << "Type,Status,Id,Parent Id,Campaign,Sync Time,Time Zone,Budget,Budget Type,Name,Campaign Type\n"
          tempfile << "Format Version,,,,,,,,,4.0,\n"
            tempfile << "Account,,#{default_options[:account_id]},21025739,,,,,,,\n"
            tempfile << "Campaign,Active,,#{default_options[:account_id]},Test Campaign #{SecureRandom.uuid},,Santiago,2000,DailyBudgetStandard,,SearchAndContent\n"
            tempfile << "Campaign,Active,,#{default_options[:account_id]},Test Campaign #{SecureRandom.uuid},,Santiago,2000,DailyBudgetStandard,,SearchAndContent\n"
            tempfile.rewind
            yield tempfile.path
        end
    end

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
        format_version: 4.0,
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
                bulk_download_status = service.get_bulk_download_status(@download_request_id)
            }.not_to raise_error

            expect(bulk_download_status).not_to be_nil

            expect(bulk_download_status.failed?).to eq(false)
        end

    end

    it "should retrieve a bulk upload URL and request ID" do
        account_id = default_options[:account_id]
        options = {response_mode: :errors_and_results}

        upload_request = nil
        expect{
            upload_request = service.get_bulk_upload_url(
                account_id,
                options
            )
        }.not_to raise_error

        expect(upload_request[:request_id]).not_to be_nil
        expect(upload_request[:upload_url]).not_to be_nil
    end

    it "should submit a bulk upload file and return the request ID" do
        account_id = default_options[:account_id]
        options = {response_mode: :errors_and_results}

        upload_request_id = nil
        generate_bulk_upload_file do |upload_file|
            expect{
                    upload_request_id = service.submit_bulk_upload_file(
                        upload_file,
                        account_id,
                        options
                    )
            }.not_to raise_error
        end

        expect(upload_request_id).not_to be_nil
    end

    context "when a bulk request has been requested" do
        it "should download result file" do
            account_id = default_options[:account_id]
            options = {response_mode: :errors_and_results}

            upload_request_id = nil
            generate_bulk_upload_file do |upload_file|
                upload_request_id = service.submit_bulk_upload_file(
                    upload_file,
                    account_id,
                    options
                )
            end

            tries = 0
            loop do
                upload_status = service.get_bulk_upload_status(upload_request_id)
                if upload_status.failed? || upload_status.pending_file_upload? || tries == 5
                    raise "Upload failed with status: #{upload_status.request_status}. Tried #{tries} times."
                end

                downloaded = upload_status.download_result_file(__FILE__)
                if downloaded
                    # clean up downloaded file
                    FileUtils.rm(downloaded)
                    break # success
                end
                tries += 1
                sleep(1)
            end
        end
    end

end
