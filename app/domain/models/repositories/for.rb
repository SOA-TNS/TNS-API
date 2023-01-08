# frozen_string_literal: true

require_relative 'value'
require_relative 'fm_fear'
require_relative 'fm_per'
require_relative 'fm_news'
require_relative 'fm_buysell'

module GoogleTrend
  module Repository
    # Finds the right repository for an entity object or class
    module For
      ENTITY_REPOSITORY = {
        Entity::FmBuySellEntity => FmBuySell,
        Entity::FmFearEntity    => FmFear,
        Entity::FmNewsEntity    => FmNews,
        Entity::FmPerEntity     => FmPer,
        Entity::RgtEntity       => Value
      }.freeze

      def self.klass(entity_klass)
        ENTITY_REPOSITORY[entity_klass]
      end

      def self.entity(entity_object)
        ENTITY_REPOSITORY[entity_object.class]
      end
    end
  end
end
