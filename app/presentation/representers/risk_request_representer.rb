# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'
require_relative 'rgt_representer'

module GoogleTrend
  module Representer
    # Represents folder summary about repo's folder
    class RiskRequest < Roar::Decorator
      include Roar::JSON
      include Roar::Hypermedia
      include Roar::Decorator::HypermediaConsumer

      property :name
    end
  end
end
