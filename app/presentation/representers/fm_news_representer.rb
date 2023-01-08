# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module Finmind
  module Representer
    # Represents a CreditShare value
    class FmNewsRepresenter < Roar::Decorator
      include Roar::JSON

      property :date
      property :stock_name
      property :link
      property :source
      property :title
    end
  end
end
