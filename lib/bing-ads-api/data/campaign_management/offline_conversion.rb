# -*- encoding : utf-8 -*-

module BingAdsApi

    class OfflineConversion < BingAdsApi::DataObject
        include BingAdsApi::Helpers::TimeHelper

        attr_accessor :conversion_currency_code,
          :conversion_name,
          :conversion_time,
          :conversion_value,
          :microsoft_click_id

        def initialize(attributes={})
            attributes[:conversion_time] = to_ms_time(attributes[:conversion_time])
            super(attributes)
        end

        def to_hash(keys = :underscore)
            hash = super(keys)
            hash[:'@xsi:type'] = "#{ClientProxy::NAMESPACE}:OfflineConversion"
            return hash
        end


  end

end
