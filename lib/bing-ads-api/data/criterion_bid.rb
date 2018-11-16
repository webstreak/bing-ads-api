module BingAdsApi

  class CriterionBid < BingAdsApi::DataObject
    attr_accessor :type,
      :amount,
      :multiplier

    def to_hash(keys = :camelcase)
      hash = super(keys)
      type = hash.delete('Type')
      hash[:'@xsi:type'] = "#{ClientProxy::NAMESPACE}:#{type}"
      return hash
    end

    def get_key_order
      super.concat(BingAdsApi::Config.instance.
      campaign_management_orders['criterion_bid'])
    end

  end

end
