module BingAdsApi

  class InsertionOrder < BingAdsApi::DataObject

    attr_accessor :account_id,
      :balance_amount,
      :booking_country_code,
      :comment,
      :end_date,
      :insertion_order_id,
      :last_modified_by_user_id,
      :last_modified_time,
      :notification_threshold,
      :reference_id,
      :spend_cap_amount,
      :start_date,
      :name,
      :status,
      :purchase_order,
      :change_pending_review

      def to_hash(keys = :underscore)
        hash = super(keys)
        hash = hash.map{ |k,v| ["ins1:#{k}", v] }.to_h
        return hash
      end

      private

        def get_key_order
          super.concat(BingAdsApi::Config.instance.
            customer_billing_orders['insertion_order'])
        end

  end

end
