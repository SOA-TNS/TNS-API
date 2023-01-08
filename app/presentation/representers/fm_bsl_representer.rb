# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module Finmind
  module Representer
    # Represents a CreditShare value
    class FmBslRepresenter < Roar::Decorator
      include Roar::JSON

      property :id
      property :stock_name
      property :name
      property :buy
      property :sell
    end
  end
end
