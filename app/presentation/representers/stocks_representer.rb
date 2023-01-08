# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'openstruct_with_links'
require_relative 'rgt_representer'

module GoogleTrend
  module Representer
    class StocksList < Roar::Decorator
      include Roar::JSON

      collection :stocks, extend: Representer::RgtRepresenter, class: Representer::OpenStructWithLinks
    end
  end
end
