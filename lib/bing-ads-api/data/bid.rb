# -*- encoding : utf-8 -*-

module BingAdsApi

    # Public: Define a bid
    #
    # Author:: alex.cavalli@offers.com
    #
    # Examples
    #   bid = BingAdsApi::Bid.new(:amount => 1.23)
    #   # => <BingAdsApi::Bid>
    class Bid < BingAdsApi::DataObject

        attr_accessor :amount

    end
end
