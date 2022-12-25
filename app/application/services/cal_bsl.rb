# frozen_string_literal: true

require 'dry/transaction'

module Finmind
  module Service
    # Analyzes contributions to a project
    class CalBsl
      include Dry::Transaction

      step :find_stock_details
      step :cal_bsl

      private

      NO_STOCK_ERR = 'Stock not found'
      DB_ERR = 'Having trouble accessing the database'
      SIZE_ERR = 'Project too large to analyze'
      PROCESSING_MSG = 'Processing the summary request'

      # Steps

      def find_stock_details(input) 
        input[:data_record] = Repository::For.klass(Entity::FmBuySellEntity).find_stock_name(input[:requested])
        input[:data_record] ? Success(input) : Failure(Response::ApiResult.new(status: :not_found, message: NO_STOCK_ERR))
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: DB_ERR))
      end

      def cal_bsl(input)
        input[:net_buy_probability] = Mapper::FmDataPreprocessing.new(input[:data_record]).to_entity
        main_info = Response::FmBslInfo.new(input[:data_record], input[:net_buy_probability])
        Success(Response::ApiResult.new(status: :ok, message: main_info))
      rescue StandardError
        App.logger.error "Could not find: #{input[:requested]}"
        Failure(Response::ApiResult.new(status: :not_found, message: NO_STOCK_ERR))
      end

    end
  end
end
