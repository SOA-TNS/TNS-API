# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'
require_relative 'rgt_representer'

module GoogleTrend
  module Representer
    # Represents folder summary about repo's folder
    class MainRepresenter < Roar::Decorator
      include Roar::JSON

      property :query
      property :risk
      property :interest_over_time
    end
  end
end
