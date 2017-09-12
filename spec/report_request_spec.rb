# -*- encoding : utf-8 -*-
require 'spec_helper'

# Author:: jlopezn@neonline.cl
describe BingAdsApi::ReportRequest do
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
