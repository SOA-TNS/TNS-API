# frozen_string_literal: false

require 'dry-types'
require 'dry-struct'

module GoogleTrend
  module Entity
    class RgtEntity < Dry::Struct
      include Dry.Types

      attribute :id,        Integer.optional
      attribute :query,     Strict::String
      attribute :time_series, Strict::String   # Array

      def to_attr_hash
        to_hash.except(:id)
      end
    end
  end
end
