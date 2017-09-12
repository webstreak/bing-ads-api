# -*- encoding : utf-8 -*-

require 'open-uri'

module BingAdsApi

  ##
  # Public: Wrapper class for GetBulkUploadStatusResponse. Not an
  # actual data object in the Bing API.
  #
  # http://msdn.microsoft.com/en-US/library/dn600289.aspx
  #
  # Author:: alex.cavalli@offers.com
  class BulkUploadStatus < BingAdsApi::DataObject

    # Valid request status
    REQUEST_STATUS = BingAdsApi::Config.instance.
      bulk_constants['request_status_type']

    attr_accessor :errors, :forward_compatibility_map, :percent_complete,
      :request_id, :request_status, :result_file_url

    # Public:: Returns true if the status is completed
    #
    # Author:: alex.cavalli@offers.com
    #
    # Returns:: boolean
    def completed?
      return request_status == REQUEST_STATUS['completed']
    end

    # Public:: Returns true if the status is completed with errors
    #
    # Author:: alex.cavalli@offers.com
    #
    # Returns:: boolean
    def completed_with_errors?
      return request_status == REQUEST_STATUS['completed_with_errors']
    end

    # Public:: Returns true if the status is failed
    #
    # Author:: alex.cavalli@offers.com
    #
    # Returns:: boolean
    def failed?
      return request_status == REQUEST_STATUS['failed']
    end

    # Public:: Returns true if the status is file uploaded
    #
    # Author:: alex.cavalli@offers.com
    #
    # Returns:: boolean
    def file_uploaded?
      return request_status == REQUEST_STATUS['file_uploaded']
    end

    # Public:: Returns true if the request_status is in progress
    #
    # Author:: alex.cavalli@offers.com
    #
    # Returns:: boolean
    def in_progress?
      return request_status == REQUEST_STATUS['in_progress']
    end

    # Public:: Returns true if the status is pending file upload
    #
    # Author:: alex.cavalli@offers.com
    #
    # Returns:: boolean
    def pending_file_upload?
      return request_status == REQUEST_STATUS['pending_file_upload']
    end

    # Public:: Attempts to download the result file to the specified directory.
    # The file name will be the request id appended with ".zip".
    #
    # Author:: alex.cavalli@offers.com
    #
    # === Parameters
    # +target_directory+ - Directory or file in directory to download the upload
    # results file to.
    #
    # Returns:: The downloaded file path if success, or nil if failure.
    def download_result_file(target_directory)
      return nil unless completed? || completed_with_errors?

      dir = Dir.exists?(target_directory) ? target_directory : File.dirname(target_directory)
      raise ArgumentError, "Could not determine target directory from argument: #{target_directory}" unless Dir.exists?(dir)

      result_file_target = File.join(dir, "#{request_id}.zip")

      File.open(result_file_target, "wb") do |result_file|
        result_file << open(result_file_url).read
      end
    end

  end

end
