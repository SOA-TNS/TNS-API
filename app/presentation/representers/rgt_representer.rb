# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module GoogleTrend
  module Representer
    # Represents a CreditShare value
    class RgtRepresenter < Roar::Decorator
      include Roar::JSON

      property :query
      property :time_series
    end
  end
end
