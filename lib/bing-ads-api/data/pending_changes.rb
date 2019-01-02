module BingAdsApi

  class PendingChanges < BingAdsApi::DataObject

    attr_accessor :comment,
      :end_date,
      :requested_by_user_id,
      :modified_date_time,
      :notification_threshold,
      :reference_id,
      :spend_cap_amount,
      :start_date,
      :name,
      :purchase_order,
      :change_status

      def to_hash(keys = :underscore)
        hash = super(keys)
        hash = hash.map{ |k,v| ["ins1:#{k.to_s.camelcase}", v] }.to_h
        return hash
      end

      private

        def get_key_order
          super.concat(BingAdsApi::Config.instance.
            customer_billing_orders['pending_changes'])
        end

  end

end
