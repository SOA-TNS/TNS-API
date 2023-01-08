# frozen_string_literal: true

require 'dry/monads'

module GoogleTrend
  module Service
    # Retrieves array of all listed project entities
    class ListStocks
      include Dry::Transaction

      step :validate_list
      step :retrieve_projects

      private

      DB_ERR = 'Cannot access database'

      def validate_list(input)
        list_request = input[:list_request].call
        if list_request.success?
          Success(input.merge(list: list_request.value!))
        else
          Failure(list_request.failure)
        end
      end

      def retrieve_projects(input)
        Repository::For.klass(Entity::RgtEntity).find_stock_names(input[:list])
          .then { |stocks| Response::StocksList.new(stocks) }
          .then { |list| Response::ApiResult.new(status: :ok, message: list) }
          .then { |result| Success(result) }
      rescue StandardError
        Failure(
          Response::ApiResult.new(status: :internal_error, message: DB_ERR)
        )
      end
    end
  end
end
