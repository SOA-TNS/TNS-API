# frozen_string_literal: true

require 'dry/transaction'

module Finmind
  module Service
    # Analyzes contributions to a project
    class CalBsl
      include Dry::Transaction

      step :find_stock_details
      step :stock_from_fmBuySell
      step :cal_bsl

      private

      NO_STOCK_ERR = 'Stock not found'
      DB_ERR = 'Having trouble accessing the database'
      SIZE_ERR = 'Project too large to analyze'
      PROCESSING_MSG = 'Processing the summary request'

      # Steps

      def find_stock_details(input)
        input[:data_record] = Repository::For.klass(Entity::FmBuySellEntity).find_stock_name(input[:requested])
        Success(input)
      rescue StandardError
        Failure(Response::ApiResult.new(status: :internal_error, message: DB_ERR))
      end

      def stock_from_fmBuySell(input)
        return Success(input) if input[:data_record]

        Messaging::Queue.new(App.config.FM_QUEUE_URL, App.config)
          # .send(fm_request_json(input))
          .send(Representer::FmBslRepresenter.new(input[:project]).to_json)

        Failure(Response::ApiResult.new(
                  status: :processing,
                  message: { request_id: input[:request_id], msg: PROCESSING_MSG }
                ))
      rescue StandardError
        raise GH_NOT_FOUND_MSG
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
