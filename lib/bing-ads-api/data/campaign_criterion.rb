module BingAdsApi

  class CampaignCriterion < BingAdsApi::DataObject
    attr_accessor :campaign_id,
      :criterion

    def to_hash(keys = :camelcase)
      hash = super(keys)
      hash[:'@xsi:type'] = "#{ClientProxy::NAMESPACE}:BiddableCampaignCriterion"
      return hash
    end

  end

end
