# frozen_string_literal: true

require_relative '../../models/mappers/fm_per_mapper'
require_relative '../../models/mappers/fmBuySell_mappers'
require_relative '../../models/entities/fm_per_entities'
require_relative '../../models/entities/fm_buysell_entities'
require_relative '../values/fm_per_strategy'
require_relative '../values/fm_div_strategy'
require_relative '../values/fm_bsl_strategy'
require_relative '../entities/main_page_fm_entity'

module GoogleTrend
  module Mapper
    class FmBuySellPreprocessing
      def initialize(entity_class)
        @entity_class = entity_class
      end

      def data_transform(data)
        data = data.split(', ')
        data[0] = data[0][1..]
        data[(data.length - 1)] = data[(data.length - 1)][..-2]
        data.map!(&:to_f)
        data
      end

      def buy_sell_diff
        buy_value = data_transform(@entity_class.buy)
        sell_value = data_transform(@entity_class.sell)
        diff = []
        (0...buy_value.length).each do |i|
          diff.append(buy_value[i] - sell_value[i])
        end
        diff
      end

      def to_entity
        GoogleTrend::Entity::FmBuySellEntity.new(
          id: nil,
          stock_name: nil,
          name: nil,
          buy: GoogleTrend::Value::FmBslStrategy.new(buy_sell_diff).net_buy_probability,
          sell: nil
        )
      end
    end
  end
end
