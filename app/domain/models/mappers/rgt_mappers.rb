# frozen_string_literal: true

module GoogleTrend
  module Gt
    class TrendMapper
      def initialize(name, api_key, gateway_class = GoogleTrend::Gt::RgtApi)
        @api_key = api_key
        @name = name
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@api_key, @name)
      end

      def find
        rgt = @gateway.jason
        build_entity(rgt)
      end

      def build_entity(rgt)
        DataMapper.new(rgt).build_entity
      end

      class DataMapper
        def initialize(rgt)
          @rgt = rgt
        end

        def build_entity
          GoogleTrend::Entity::RgtEntity.new(
            id: nil,
            query:,
            time_series:
          )
        end

        def query
          @rgt['search_parameters']['q']
        end

        def time_series
          array = []
          interest_over_time = @rgt['interest_over_time'] # hash
          time_series_data = interest_over_time['timeline_data'] # array
          time_series_data.each { |data| array << "#{data['date']} => #{data['values'][0]['value']}" }
          array.to_s
        end
      end
    end
  end
end
