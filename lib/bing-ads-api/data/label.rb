module BingAdsApi
  class Label
    attr_accessor :color_code,
      :description,
      :id,
      :name
  end

  private

  def get_key_order
    super.concat(BingAdsApi::Config.instance.
      campaign_management_orders['label'])
  end
end
