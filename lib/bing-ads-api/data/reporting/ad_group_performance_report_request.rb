module BingAdsApi

    class AdGroupPerformanceReportRequest < BingAdsApi::PerformanceReportRequest
        COLUMNS = BingAdsApi::Config.instance.
            reporting_constants['ad_group_performance_report']['columns']
        FILTERS = BingAdsApi::Config.instance.
            reporting_constants['ad_group_performance_report']['filter']
        attr_accessor :max_rows, :sort

        def initialize(attributes={})
            raise Exception.new("Invalid columns") if !valid_columns(COLUMNS, attributes[:columns])
            raise Exception.new("Invalid filters") if !valid_filter(FILTERS, attributes[:filter])
            super(attributes)
        end

        def to_hash(keys = :underscore)
            hash = super(keys)
            hash[get_attribute_key('columns', keys)] =
                columns_to_hash(COLUMNS, columns, keys)
            hash[get_attribute_key('filter', keys)] =
                filter_to_hash(FILTERS, keys)
            hash[get_attribute_key('scope', keys)] = scope_to_hash(keys)
            hash[get_attribute_key('max_rows', keys)] = max_rows if max_rows
            hash[get_attribute_key('sort', keys)] = sort_to_hash(keys) if sort
            hash["@xsi:type"] = type_attribute_for_soap
            return hash
        end


        private

            def scope_to_hash(keys_case=:underscore)
                return {
                    get_attribute_key('account_ids', keys_case) =>
                        {"ins0:long" => object_to_hash(scope[:account_ids], keys_case) },
                    get_attribute_key('ad_group', keys_case) =>
                        { "AdGroupReportScope" => object_to_hash(scope[:ad_groups], keys_case) },
                    get_attribute_key('campaigns', keys_case) =>
                        { "CampaignReportScope" => object_to_hash(scope[:campaigns], keys_case) }
                }
            end

            def sort_to_hash(keys_case=:underscore)
                sort.map { |sort_object| object_to_hash(sort_object, keys_case) }
            end

            def type_attribute_for_soap
                return BingAdsApi::ClientProxy::NAMESPACE.to_s + ":" +
                    BingAdsApi::Config.instance.
                        reporting_constants['ad_group_performance_report']['type']
            end
    end

end
