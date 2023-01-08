# frozen_string_literal: true

require_relative '../../../infrastructure/gateways/findmind_api'

module GoogleTrend
  module Gt
    class FmFearMapper
      def initialize(data_id, start_date = (Time.now - (3600 * 24 * 60)).to_s[0..9], end_date = Time.now.to_s[0..9],
                     gateway_class = Gt::StockApi)
        @data_id = data_id
        @gateway_class = gateway_class
        @start_date = start_date
        @end_date = end_date
        @gateway = @gateway_class.new('CnnFearGreedIndex', @data_id, @start_date, @end_date)
      end

      def find
        stock = @gateway.jason
        build_entity(stock)
      end

      def build_entity(stock)
        DataMapper.new(stock).build_entity
      end

      class DataMapper
        def initialize(stock)
          @stock = stock
        end

        def build_entity
          GoogleTrend::Entity::FmFearEntity.new(
            id: nil,
            time:,
            fear_greed:,
            fear_greed_emotion:
          )
        end

        def time
          date = []
          value_over_time = @stock['data'] # hash
          value_over_time.each { |value| date << value['date'] } # array
          date.to_s
        end

        def fear_greed
          fear_greed = []
          value_over_time = @stock['data'] # hash
          value_over_time.each { |value| fear_greed << value['fear_greed'] } # array
          fear_greed.to_s
        end

        def fear_greed_emotion
          fear_greed_emotion = []
          value_over_time = @stock['data'] # hash
          value_over_time.each { |value| fear_greed_emotion << value['fear_greed_emotion'] } # array
          fear_greed_emotion.to_s
        end
      end
    end
  end
end
