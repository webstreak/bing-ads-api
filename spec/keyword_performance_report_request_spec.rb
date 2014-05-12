require 'spec_helper'

describe BingAdsApi::KeywordPerformanceReportRequest do
  it "should initialize campaign performance report request" do
    expect{
      request = BingAdsApi::KeywordPerformanceReportRequest.new(
        :format   => :xml,
        :language => :english,
        :report_name => "Me report",
        :aggregation => :hourly,
        :columns => [:account_name, :account_number, :time_period],
        # The filter is specified as a hash
        :filter => {
          # specifies the Bing expected String value
          :ad_distribution => "Search",
          :ad_type => "Text",
          :bid_match_type => "Exact",
          :delivered_match_type => "Exact",
          # specifies criteria as a snake case symbol
          :device_type => :tablet,
          :keyword_relevance => [3],
          :keywords => ["bing ads"],
          :landing_page_relevance => [2],
          :landing_page_user_experience => [2],
          :language_code => ["EN"],
          :quality_score => [7,8,9,10] },
        :max_rows => 10,
        :scope => {
          :account_ids => [123456, 234567] },
        # predefined date
        :time => :this_week)
    }.not_to raise_error
  end
end
