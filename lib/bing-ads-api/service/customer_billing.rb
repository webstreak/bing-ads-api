# -*- encoding : utf-8 -*-
module BingAdsApi


    # Public : This class represents the Campaign Management Services
    # defined in the Bing Ads API, to manage advertising campaigns
    #
    # Author:: jlopezn@neonline.cl
    #
    # Examples
    #  options = {
    #    :environment => :sandbox,
    #    :username => "username",
    #    :password => "pass",
    #    :developer_token => "SOME_TOKEN",
    #    :customer_id => "1234567",
    #    :account_id => "9876543" }
    #  service = BingAdsApi::CampaignManagement.new(options)
    class CustomerBilling < BingAdsApi::Service


        # Public : Constructor
        #
        # Author:: jlopezn@neonline.cl
        #
        # options - Hash with the parameters for the client proxy and the environment
        #
        # Examples
        #   options = {
        #     :environment => :sandbox,
        #     :username => "username",
        #     :password => "password",
        #     :developer_token => "DEV_TOKEN",
        #     :customer_id => "123456",
        #     :account_id => "654321"
        #   }
        #   service = BingAdsApi::CampaignManagement.new(options)
        def initialize(options={})
          super(options)
        end


        #########################
        ## Operations Wrappers ##
        #########################

        # Public : Returns insertion orders based on specific conditions
        #
        # Author:: dmitrii@webstreak.com
        #
        # === Parameters
        # predicates
        #
        # Returns:: Array of Insertion Orders
        #
        # Raises:: exception
        def search_insertion_orders(account_id, predicates)
          #predicate = BingAdsApi::Predicate.new(field: 'AccountId', operator: 'Equals', value: account_id)
          if predicates.is_a? Array
            predicates_for_soap = predicates.map{ |p| p.to_hash(:camelcase) }
          elsif predicates.is_a? BingAdsApi::Predicate
            predicates_for_soap = predicates.to_hash(:camelcase)
          else
            raise "predicates must be an array or instance of BingAdsApi::Predicate"
          end
          response = call(:search_insertion_orders,
            { predicates: { "ins1:Predicate" => predicates_for_soap },
              page_info: {
                "ins1:Index" => 0,
                "ins1:Size" => 10
              }
            }
          )
          response_hash = get_response_hash(response, __method__)
          response_orders = [response_hash[:insertion_orders][:insertion_order]].flatten.compact
          insertion_orders = response_orders.map{ |insertion_order_hash| BingAdsApi::InsertionOrder.new(insertion_order_hash) }
          return insertion_orders
        end

        def add_insertion_order(insertion_order)
          response = call(:add_insertion_order, { insertion_order: insertion_order.to_hash(:camelcase) } )
          response_hash = get_response_hash(response, __method__)
          return response_hash[:insertion_order_id]
        end
        #it's important to use format ("%Y-%m-%dT%H:%M:%S.%L") for all DateTime params"
        def update_insertion_order(insertion_order, changes)
          insertion_order.pending_changes = changes
          response = call(:update_insertion_order, { insertion_order: insertion_order.to_hash(:camelcase) } )
          response_hash = get_response_hash(response, __method__)
          return response_hash
        end

    private

      def get_service_name
        "customer_billing"
      end

    end

end
