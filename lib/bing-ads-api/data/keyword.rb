# -*- encoding : utf-8 -*-

module BingAdsApi

    # Public: Define a keyword
    #
    # Author:: alex.cavalli@offers.com
    #
    # Examples
    #   keyword = BingAdsApi::Keyword.new(
    #     :bid => BingAdsApi::Bid.new(:amount => 1.23),
    #     :destination_url => "http://www.example.com/",
    #     :id => 123456789,
    #     :match_type => BingAdsApi::Keyword::EXACT,
    #     :param1 => "param1",
    #     :param2 => "param2",
    #     :param3 => "param3",
    #     :status => BingAdsApi::Keyword::ACTIVE,
    #     :text => "keyword text")
    #   # => <BingAdsApi::Keyword>
    class Keyword < BingAdsApi::DataObject
        include BingAdsApi::KeywordEditorialStatuses
        include BingAdsApi::KeywordStatuses
        include BingAdsApi::MatchTypes


        attr_accessor :bid,
            :destination_url,
            :editorial_status,
            :forward_compatibility_map,
            :id,
            :match_type,
            :param1,
            :param2,
            :param3,
            :status,
            :text

        private

            # Internal: Retrieve the ordered array of keys corresponding to this data
            # object.
            #
            # Author: alex.cavalli@offers.com
            def get_key_order
                super.concat(BingAdsApi::Config.instance.
                    campaign_management_orders['keyword'])
            end

    end
end
