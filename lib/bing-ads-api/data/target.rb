# -*- encoding : utf-8 -*-

module BingAdsApi

    ##
    # Public : Defines the base object of an location target.
    #
    # Reference: https://msdn.microsoft.com/library/4349d964-0553-4d68-a53e-5011ff51a8f9
    #
    # Author:: seodma@gmailc.com
    #
    class Target < BingAdsApi::DataObject

        attr_accessor :id, :location

        def to_hash(keys = :camelcase)
            hash = super(keys)
            return hash
        end

    end

end
