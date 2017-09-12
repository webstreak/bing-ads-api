# -*- encoding : utf-8 -*-

module BingAdsApi

    ##
    # Public : Base Class to define Bing API data objects
    # Do not use this class directly, use any of the derived classes
    #
    # Author:: jlopezn@neonline.cl
    #
    class DataObject


        include BingAdsApi::SOAPHasheable

        # Public : Constructor in a ActiveRecord style, with a hash of attributes as input
        #
        # Author:: jlopezn@neonline.cl
        #
        # attributes - Hash with the objects attributes
        def initialize(attributes={})
            attributes.each { |key, val| send("#{key}=", val) if respond_to?("#{key}=") }
        end


        # Public : Specified to string method
        #
        # Author:: jlopezn@neonline.cl
        def to_s
            to_hash.to_s
        end


        # Public: Convert this object's attributes into hash format. It will
        # automatically apply key ordering.
        #
        # Author:: alex.cavalli@offers.com
        #
        # === Parameters
        # * +keys_case+ - specifies the hash keys case, default 'underscore'
        # ==== keys_case
        # * :camelcase  - CamelCase
        # * :underscore - underscore_case
        def to_hash(keys_case=:underscore)
            hash = super
            apply_order(hash)
            hash
        end

        private


        # Internal: Add an :order! key to the hash pointing to an array of all the
        # keys in the hash according to the order from the config file.
        #
        # Author: alex.cavalli@offers.com
        #
        # === Parameters
        # * +hash+ - the hash to apply an id-elevated order to
        def apply_order(hash)
            key_order = get_key_order
            return if key_order.empty?
            key_order = key_order.map { |key| key.to_s.camelcase }
            key_order = key_order & hash.keys # remove keys from order not present in hash
            hash[:order!] = key_order
        end


        # Internal: Retrieve the ordered array of keys corresponding to this data
        # object. Should be overriden by children.
        #
        # Author: alex.cavalli@offers.com
        def get_key_order
            []
        end

    end
end
