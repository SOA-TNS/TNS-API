# frozen_string_literal: true

require 'dry/transaction'

module Finmind
  module Service
    # Analyzes contributions to a project
    class CalDiv
      include Dry::Transaction

      step :find_stock_details
      step :cal_div

      private

      NO_STOCK_ERR = 'Stock not found'
      DB_ERR = 'Having trouble accessing the database'
      SIZE_ERR = 'Project too large to analyze'
      PROCESSING_MSG = 'Processing the summary request'

      # Steps

      def find_stock_details(input)
        input[:data_record] = Repository::For.klass(Entity::FmPerEntity).find_stock_name(input[:requested])
        if input[:data_record]
          Success(input)
        else
          Failure(Response::ApiResult.new(status: :not_found,
                                          message: NO_STOCK_ERR))
        end
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: DB_ERR))
      end

      def cal_div(input)
        input[:avg_dividend_yield] = Mapper::FmDataPreprocessing.new(input[:data_record]).to_entity
        main_info = Response::FmDivInfo.new(input[:data_record], input[:avg_dividend_yield])
        Success(Response::ApiResult.new(status: :ok, message: main_info))
      rescue StandardError
        App.logger.error "Could not find: #{input[:requested]}"
        Failure(Response::ApiResult.new(status: :not_found, message: NO_STOCK_ERR))
      end
    end
  end
end
