require 'rest_client'

# -*- encoding : utf-8 -*-
module BingAdsApi

    # Public: This class represents the Bulk Services defined in the Bing Ads API
    # to request and download and upload bulk account and campaign data
    #
    # Author:: alex.cavalli@offers.com
    #
    # Examples
    #  options = {
    #    :environment => :sandbox,
    #    :username => "username",
    #    :password => "pass",
    #    :developer_token => "SOME_TOKEN",
    #    :customer_id => "1234567",
    #    :account_id => "9876543" }
    #  service = BingAdsApi::Bulk.new(options)
    class Bulk < BingAdsApi::Service

        # Valid download file types for bulk API
        DOWNLOAD_FILE_TYPES = BingAdsApi::Config.instance.
            bulk_constants['download_file_type']

        RESPONSE_MODES = BingAdsApi::Config.instance.
            bulk_constants['response_mode']

        # Public: Issue a download request for all entities in an account.
        #
        # http://msdn.microsoft.com/en-us/library/jj885755.aspx
        #
        # Author:: alex.cavalli@offers.com
        #
        # === Parameters
        # +account_ids+ - Array of account ids
        # +entities+ - Array of entities
        # +options+ - Hash of additional options
        #
        # === Examples
        #   service.download_campaigns_by_account_ids(
        #     [1,2,3],
        #     [:campaigns, :ad_groups, :keywords, :ads],
        #     data_scope: :entity_data,
        #     download_file_type: :csv,
        #     format_version: 2.0,
        #     last_sync_time_in_utc: "2001-10-26T21:32:52",
        #     location_target_version: "Latest",
        #     performance_stats_date_range: {
        #           custom_date_range_end:   {day: 31, month: 12, year: 2013},
        #           custom_date_range_start: {day: 1, month: 12, year: 2013}
        #       }
        #   )
        #   # => "1234567890"
        #
        # Returns:: String with the download request id
        #
        # Raises:: exception
        def download_campaigns_by_account_ids(account_ids, entities, options={})
            download_request = {
                account_ids: {"ins0:long" => account_ids},
            data_scope: data_scope_to_array(options[:data_scope]),
            download_file_type: DOWNLOAD_FILE_TYPES[options[:download_file_type].to_s],
                entities: entities_for_soap(entities),
            format_version: options[:format_version] || 4.0,
            last_sync_time_in_utc: options[:last_sync_time_in_utc],
            location_target_version: options[:location_target_version],
            performance_stats_date_range: options[:performance_stats_date_range]
            }

            response = call(:download_campaigns_by_account_ids,
                download_request)
            response_hash = get_response_hash(response, __method__)
            download_request_id = response_hash[:download_request_id]
            return download_request_id
        end


        # Public: Get an upload URL and corresponding request ID. The URL can be
        # used to post a bulk upload file to, and the request ID can be used to
        # track the status of the request once the file has been posted. See
        # http://msdn.microsoft.com/en-US/library/bing-ads-bulk-download-and-upload-guide.aspx#bulkupload
        #
        # Author:: alex.cavalli@offers.com
        #
        # === Parameters
        # +account_id+ - An account id to apply the bulk upload to
        # +options+ - Hash of additional options
        #
        # === Examples
        #   service.get_bulk_upload_url(111)
        #   # => {request_id: 222, upload_url: "http://www.example.com/"}
        #
        # Returns:: Hash with the upload URL and upload request ID
        #
        # Raises:: exception
        def get_bulk_upload_url(account_id, options={})
            response = call(:get_bulk_upload_url,
                response_mode: RESPONSE_MODES[options[:response_mode].to_s],
                account_id: account_id,
            )
            response_hash = get_response_hash(response, __method__)
            return response_hash
        end


        # Public: Post a bulk upload file to the Bing Ads API and return the bulk
        # request ID. This method does not map to a specific service call in the
        # Bing Ads API, but wraps the GetBulkUploadUrl call and POSTs the file
        # upload to the provided upload URL.
        # http://msdn.microsoft.com/en-US/library/bing-ads-bulk-download-and-upload-guide.aspx#bulkupload
        #
        # Author:: alex.cavalli@offers.com
        #
        # === Parameters
        # +file+ - A path to the CSV/TSV bulk file to upload
        # +account_id+ - An account id to apply the bulk upload to
        # +options+ - Hash of additional options
        #
        # === Examples
        #   service.submit_bulk_upload_file("bulk_upload.csv", 111)
        #   # => "1234567890"
        #
        # Returns:: String with the upload request id
        #
        # Raises:: exception
        def submit_bulk_upload_file(file, account_id, options={})
            upload_request = get_bulk_upload_url(account_id, options)

            # TODO: Extract this HTTP interface to separate object
            response = RestClient.post(
                upload_request[:upload_url],
                {file: File.new(file)},
                "UserName" => client_proxy.username,
                "Password" => client_proxy.password,
                "DeveloperToken" => client_proxy.developer_token,
                "CustomerId" => client_proxy.customer_id,
                "AccountId" => account_id,
            )

            raise "File upload failed. HTTP response:\n#{response.to_str}" unless response.code == 200

            return upload_request[:request_id]
        end


        # Public: Get the status of a report request
        #
        # Author:: alex.cavalli@offers.com
        #
        # === Parameters
        # +download_request_id+ - Identifier of the report request
        #
        # === Examples
        #   service.get_bulk_download_status("12345")
        #   # => BulkDownloadStatus
        #
        # Returns:: BulkDownloadStatus
        #
        # Raises:: exception
        def get_bulk_download_status(download_request_id)
            response = call(:get_bulk_download_status,
                {request_id: download_request_id} )
            response_hash = get_response_hash(response, __method__)
            return BingAdsApi::BulkDownloadStatus.new(response_hash)
        end


        # Public: Get the status of a upload request
        #
        # Author:: alex.cavalli@offers.com
        #
        # === Parameters
        # +upload_request_id+ - Identifier of the upload request
        #
        # === Examples
        #   service.get_bulk_upload_status("12345")
        #   # => BulkUploadStatus
        #
        # Returns:: BulkUploadStatus
        #
        # Raises:: exception
        def get_bulk_upload_status(upload_request_id)
            response = call(:get_bulk_upload_status,
                {request_id: upload_request_id} )
            response_hash = get_response_hash(response, __method__)
            return BingAdsApi::BulkUploadStatus.new(response_hash.merge('request_id' => upload_request_id))
        end


        private
            def get_service_name
                "bulk"
            end


            # Internal: Converts data scope symbols (in snake case) to camelcased
            # variants for SOAP.
            #
            # Author:: alex.cavalli@offers.com
            #
            # Returns:: Array
            def data_scope_to_array(data_scope)
                return nil unless data_scope

                valid_entities = BingAdsApi::Config.instance.bulk_constants['data_scope']

                Array(data_scope).map do |data_scope|
                    if data_scope.is_a?(String)
                        data_scope
                    elsif data_scope.is_a?(Symbol)
                        valid_entities[data_scope.to_s]
                    end
                end
            end


            # Internal: Converts entity symbols (in snake case) to camelcased variants
            # for SOAP and joins them by whitespace characters.
            #
            # Author:: alex.cavalli@offers.com
            #
            # Returns:: String
            def entities_for_soap(entities)
                raise Exception.new("Invalid entities value: nil") unless entities

                valid_entities = BingAdsApi::Config.instance.bulk_constants['entities']

                entities.map do |entity|
                    if entity.is_a?(String)
                        entity
                    elsif entity.is_a?(Symbol)
                        valid_entities[entity.to_s]
                    end
                end.join(" ")
            end

    end
end
