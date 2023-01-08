# frozen_string_literal: true

require_relative '../../../infrastructure/gateways/findmind_api'

module GoogleTrend
  module Gt
    class FmPerMapper
      def initialize(data_id, start_date = (Time.now - (3600 * 24 * 60)).to_s[0..9], end_date = Time.now.to_s[0..9],
                     gateway_class = Gt::StockApi)
        @data_id = data_id
        @gateway_class = gateway_class
        @start_date = start_date
        @end_date = end_date
        @gateway = @gateway_class.new('TaiwanStockPER', @data_id, @start_date, @end_date)
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
          GoogleTrend::Entity::FmPerEntity.new(
            id: nil,
            stock_name:,
            time:,
            div_yield:,
            per:,
            pbr:
          )
        end

        def stock_name
          @stock['data'][0]['stock_id']
        end

        def time
          date = []
          value_over_time = @stock['data'] # hash
          value_over_time.each { |value| date << value['date'] }
          date.to_s
        end

        def div_yield
          div_yied = []
          value_over_time = @stock['data']
          value_over_time.each { |value| div_yied << value['dividend_yield'] } # array
          div_yied.to_s
        end

        def per
          per = []
          value_over_time = @stock['data'] # hash
          value_over_time.each { |value| per << value['PER'] }
          per.to_s
        end

        def pbr
          pbr = []
          value_over_time = @stock['data'] # hash
          value_over_time.each { |value| pbr << value['PBR'] }
          pbr.to_s
        end
      end
    end
  end
end
