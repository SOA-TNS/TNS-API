# frozen_string_literal: true

require 'sequel'

module GoogleTrend
  module Database
    # Object-Relational Mapper for Members
    class FmNewsOrm < Sequel::Model(:fm_news)
      plugin :timestamps, update_on_create: true
    end
  end
end
