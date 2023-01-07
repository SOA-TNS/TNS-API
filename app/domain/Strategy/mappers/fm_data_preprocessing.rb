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
    class FmDataPreprocessing
      def initialize(per_entity_class = GoogleTrend::Entity::FmPerEntity,
                     bsl_entity_class = GoogleTrend::Entity::FmBuySellEntity,
                     fear_entity_class = GoogleTrend::Entity::FmFearEntity)
        @fear_entity_class = fear_entity_class
        @per_entity_class = per_entity_class
        @bsl_entity_class = bsl_entity_class
      end

      def data_transform(data)
        data = data.split(', ')
        data[0] = data[0][1..]
        data[(data.length - 1)] = data[(data.length - 1)][..-2]
        data.map!(&:to_f)
        data
      end

      def per_value
        data_transform(@per_entity_class.per)
      end

      def div_yield_value
        data_transform(@per_entity_class.div_yield)
      end

      def fear_value
        data_transform(@fear_entity_class.fear_greed_index)
      end

      def buy_sell_diff
        buy_value = data_transform(@bsl_entity_class.buy)
        sell_value = data_transform(@bsl_entity_class.sell)
        diff = []
        (0...buy_value.length).each do |i|
          diff.append(buy_value[i] - sell_value[i])
        end
        diff
      end

      def to_entity
        Entity::MainPageFmEntity.new(
          avg_per: GoogleTrend::Value::FmPerStrategy.new(per_value).avg_per,
          avg_dividend_yield: GoogleTrend::Value::FmDivStrategy.new(div_yield_value).avg_dividend_yield,
          net_buy_probability: GoogleTrend::Value::FmBslStrategy.new(buy_sell_diff).net_buy_probability,
          fear_value: GoogleTrend::Value::FmFearStrategy.new(fear_value).fear_value,
          fear_greed_index: GoogleTrend::Value::FmFearStrategy.new(fear_value).fr_strategy
        )
      end
    end
  end
end
