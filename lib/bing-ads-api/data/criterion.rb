module BingAdsApi

  class Criterion < BingAdsApi::DataObject
    attr_accessor :latitude_degrees,
      :longitude_degrees,
      :name,
      :radius,
      :radius_unit,
      :criterion_type

    def to_hash(keys = :camelcase)
      hash = super(keys)
      criterion_type = hash.delete('CriterionType')
      hash[:'@xsi:type'] = "#{ClientProxy::NAMESPACE}:#{criterion_type}"
      return hash
    end

     def get_key_order
        super.concat(BingAdsApi::Config.instance.
          campaign_management_orders['criterion'])
     end

  end

end
