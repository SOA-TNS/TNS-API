# frozen_string_literal: true

require 'dry/transaction'

module GoogleTrend
  module Service
    # Analyzes contributions to a project
    class RiskStock
      include Dry::Transaction

      step :find_stock_details
      step :appraise_risk

      private

      NO_STOCK_ERR = 'Stock not found'
      DB_ERR = 'Having trouble accessing the database'
      SIZE_ERR = 'Project too large to analyze'
      PROCESSING_MSG = 'Processing the summary request'

      # Steps

      def find_stock_details(input)
        input[:data_record] = Repository::For.klass(Entity::RgtEntity).find_stock_name(CGI.unescape(input[:requested]))
        if input[:data_record]
          Success(input)
        else
          Failure(Response::ApiResult.new(status: :not_found,
                                          message: NO_STOCK_ERR))
        end
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: DB_ERR))
      end

      def appraise_risk(input)
        input[:risk] = Mapper::DataPreprocessing.new(input[:data_record]).to_entity
        main_info = Response::StockInfo.new(input[:data_record], input[:risk])
        Success(Response::ApiResult.new(status: :ok, message: main_info))
      rescue StandardError
        App.logger.error "Could not find: #{input[:requested]}"
        Failure(Response::ApiResult.new(status: :not_found, message: NO_STOCK_ERR))
      end
    end
  end
end
