# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module Finmind
  module Representer
    # Represents folder summary about repo's folder
    class MainFmRepresenter < Roar::Decorator
      include Roar::JSON

      property :avg_per
      property :avg_dividend_yield
      property :net_buy_probability
    end
  end
end
