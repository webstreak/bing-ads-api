module BingAdsApi

  class CampaignCriterion < BingAdsApi::DataObject
    attr_accessor :campaign_id,
      :criterion,
      :id,
      :criterion_bid

    def to_hash(keys = :camelcase)
      hash = super(keys)
      hash[:'@xsi:type'] = "#{ClientProxy::NAMESPACE}:BiddableCampaignCriterion"
      return hash
    end

  end

end
