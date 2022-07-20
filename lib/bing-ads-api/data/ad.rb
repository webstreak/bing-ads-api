# -*- encoding : utf-8 -*-

module BingAdsApi

  ##
  # Public : Defines the base object of an ad.
  # Do not instantiate this object. Instead you can instantiate the
  # BingAdsApi::TextAd, BingAdsApi::MobileAd, or BingAdsApi::ProductAd
  # object that derives from this object.
  #
  # Reference: http://msdn.microsoft.com/en-US/library/bing-ads-campaign-management-ad.aspx
  #
  # Author:: jlopezn@neonline.cl
  #
  class Ad < BingAdsApi::DataObject
    include BingAdsApi::AdEditorialStatus
    include BingAdsApi::AdStatus
    include BingAdsApi::AdType

    attr_accessor :id,
      :device_preference,
      :editorial_status,
      :status,
      :type,
      :final_urls,
      :text,
      :title_part1,
      :title_part2,
      :tracking_url_template

    private

      # Internal: Retrieve the ordered array of keys corresponding to this data
      # object.
      #
      # Author: alex.cavalli@offers.com
      def get_key_order
        super.concat(BingAdsApi::Config.instance.
          campaign_management_orders['ad'])
      end

  end

  ##
  # Public : Defines a text ad.
  #
  # Reference: http://msdn.microsoft.com/en-US/library/bing-ads-campaign-management-textad.aspx
  #
  # Author:: jlopezn@neonline.cl
  #
  class TextAd < BingAdsApi::Ad

    attr_accessor :destination_url,
      :display_url,
      :text,
      :title

    # Public : Specification of DataObject#to_hash method that ads the type attribute based on this specific class
    #
    # Author:: jlopezn@neonline.cl
    #
    # keys - specifies the keys case
    #
    # Returns:: Hash
    def to_hash(keys = :underscore)
      hash = super(keys)
      hash[:'@xsi:type'] = "#{ClientProxy::NAMESPACE}:TextAd"
      return hash
    end

    private

      # Internal: Retrieve the ordered array of keys corresponding to this data
      # object.
      #
      # Author: alex.cavalli@offers.com
      def get_key_order
        super.concat(BingAdsApi::Config.instance.
          campaign_management_orders['text_ad'])
      end

  end

  ##
  # Public : Defines expanded text ad.
  #
  # Reference: http://msdn.microsoft.com/en-US/library/bing-ads-campaign-management-textad.aspx
  #
  # Author:: dmitrii@webstreak.com
  #
  class ExpandedTextAd < BingAdsApi::Ad

    attr_accessor :final_urls,
      :path1,
      :path2,
      :text,
      :title_part1,
      :title_part2,
      :tracking_url_template


    # Public : Specification of DataObject#to_hash method that ads the type attribute based on this specific class
    #
    # Author:: jlopezn@neonline.cl
    #
    # keys - specifies the keys case
    #
    # Returns:: Hash
    def to_hash(keys = :underscore)
      hash = super(keys)
      hash[:'@xsi:type'] = "#{ClientProxy::NAMESPACE}:ExpandedTextAd"
      new_hash = {}
      hash['FinalUrls'].each_pair do |k,v|
        next if !k.include?('string')
        new_hash.merge!( { k.downcase => v } )
      end
      hash['FinalUrls'] = new_hash
      return hash
    end

    private

      # Internal: Retrieve the ordered array of keys corresponding to this data
      # object.
      #
      # Author: alex.cavalli@offers.com
      def get_key_order
        super.concat(BingAdsApi::Config.instance.
          campaign_management_orders['expanded_text_ad'])
      end

  end

  ##
  # Public : Defines a product ad.
  #
  # Reference: http://msdn.microsoft.com/en-US/library/bing-ads-productad-campaign-management.aspx
  #
  # Author:: jlopezn@neonline.cl
  #
  class ProductAd < BingAdsApi::Ad

    attr_accessor :promotional_text

    # Public : Specification of DataObject#to_hash method that ads the type attribute based on this specific class
    #
    # Author:: jlopezn@neonline.cl
    #
    # keys - specifies the keys case
    #
    # Returns:: Hash
    def to_hash(keys = :underscore)
      hash = super(keys)
      hash[:'@xsi:type'] = "#{ClientProxy::NAMESPACE}:ProductAd"
      return hash
    end

    private

      # Internal: Retrieve the ordered array of keys corresponding to this data
      # object.
      #
      # Author: alex.cavalli@offers.com
      def get_key_order
        super.concat(BingAdsApi::Config.instance.
          campaign_management_orders['product_ad'])
      end

  end

  ##
  # Public : Defines responsive search ad.
  #
  # Reference: https://docs.microsoft.com/en-us/advertising/campaign-management-service/responsivesearchad?view=bingads-13
  #
  # Author:: mattking@gosokal.com
  #
  class ResponsiveSearchAd < BingAdsApi::Ad

    attr_accessor :descriptions, :headlines

    # Public : Specification of DataObject#to_hash method that ads the type attribute based on this specific class
    #
    # Author:: jlopezn@neonline.cl
    #
    # keys - specifies the keys case
    #
    # Returns:: Hash
    def to_hash(keys = :underscore)
      hash = super(keys)
      hash[:'@xsi:type'] = "#{ClientProxy::NAMESPACE}:ResponsiveSearchAd"
      new_hash = {}
      hash['FinalUrls'].each_pair do |k,v|
        next if !k.include?('string')
        new_hash.merge!( { k.downcase => v } )
      end
      hash['FinalUrls'] = new_hash
      hash['Headlines'] = hash['Headlines'].map do |headline|
        { 'AssetLink' => { 'TextAsset' => { 'Text' => headline, '@xsi:type' => 'TextAsset' } } }
      end
      hash['Descriptions'] = hash['Descriptions'].map do |desc|
        { 'AssetLink' => { 'TextAsset' => { 'Text' => desc, '@xsi:type' => 'TextAsset' } } }
      end
      hash
    end

    private

      # Internal: Retrieve the ordered array of keys corresponding to this data
      # object.
      #
      # Author: alex.cavalli@offers.com
      def get_key_order
        super.concat(BingAdsApi::Config.instance.
          campaign_management_orders['responsive_search_ad'])
      end

  end

end
