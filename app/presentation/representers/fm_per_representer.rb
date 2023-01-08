# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module Finmind
  module Representer
    # Represents a CreditShare value
    class FmPerRepresenter < Roar::Decorator
      include Roar::JSON

      property :id
      property :stock_name
      property :time
      property :div_yield
      property :per
      property :pbr
    end
  end
end
