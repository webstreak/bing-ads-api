# -*- encoding : utf-8 -*-

module BingAdsApi

  ##
  # Public: Wrapper class for GetBulkDownloadStatusResponse. Not an
  # actual data object in the Bing API.
  #
  # http://msdn.microsoft.com/en-US/library/dn600289.aspx
  #
  # Author:: alex.cavalli@offers.com
  class BulkDownloadStatus < BingAdsApi::DataObject

    # Valid report request status for reports
    REQUEST_STATUS = BingAdsApi::Config.instance.
      bulk_constants['request_status_type']

    attr_accessor :errors, :forward_compatibility_map, :percent_complete,
      :request_status, :result_file_url

    # Public:: Returns true if the status is completed
    #
    # Author:: alex.cavalli@offers.com
    #
    # Returns:: boolean
    def completed?
      return request_status == REQUEST_STATUS['completed']
    end

    # Public:: Returns true if the request_status is in progress
    #
    # Author:: alex.cavalli@offers.com
    #
    # Returns:: boolean
    def in_progress?
      return request_status == REQUEST_STATUS['in_progress']
    end

    # Public:: Returns true if the status is failed
    #
    # Author:: alex.cavalli@offers.com
    #
    # Returns:: boolean
    def failed?
      return request_status == REQUEST_STATUS['failed']
    end

    # Public:: Returns true if the status is failed full sync required
    #
    # Author:: alex.cavalli@offers.com
    #
    # Returns:: boolean
    def failed_full_sync_required?
      return request_status == REQUEST_STATUS['failed_full_sync_required']
    end

  end

end
