# frozen_string_literal: true

require 'dry/transaction'

module GoogleTrend
  module Service
    # Transaction to store stock from GoogleTrend API to database
    class FmPer
      include Dry::Transaction

      step :find_FmPer
      step :store_FmPer
      step :appraise_per

      private

      DB_ERR_MSG = 'Having trouble accessing the database'
      GH_NOT_FOUND_MSG = 'Could not find that stock on GoogleTrend'

      def find_FmPer(input)
        if (stock = fm_in_database(input))
          input[:local_stock] = stock
        else
          input[:remote_stock] = stock_from_fmPer(input)
        end
        Success(input)
      rescue StandardError => e
        Failure(Response::ApiResult.new(status: :not_found, message: e.to_s))
      end

      def store_FmPer(input)
        stock =
          if (new_stock = input[:remote_stock])
            GoogleTrend::Repository::For.entity(new_stock).create(new_stock)
          else
            input[:local_stock]
          end
        Success(Response::ApiResult.new(status: :created, message: stock))
      rescue StandardError => e
        puts e.backtrace.join("\n")
        Failure(Response::ApiResult.new(status: :internal_error, message: DB_ERR_MSG))
      end

      def appraise_per(input)
        Success(Response::ApiResult.new(status: :ok, message: Mapper::FmPerPreprocessing.new(input.message).to_entity))
      rescue StandardError
        App.logger.error "Could not find: #{input}"
        Failure(Response::ApiResult.new(status: :not_found, message: NO_STOCK_ERR))
      end

      def stock_from_fmPer(input)
        GoogleTrend::Gt::FmPerMapper.new(input['rgt_url']).find
      rescue StandardError
        raise GH_NOT_FOUND_MSG
      end

      def fm_in_database(input)
        Repository::For.klass(Entity::FmPerEntity).find_stock_name(input['rgt_url'])
      end
    end
  end
end
