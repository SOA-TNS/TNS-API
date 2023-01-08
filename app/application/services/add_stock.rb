# frozen_string_literal: true

require 'dry/transaction'

module GoogleTrend
  module Service
    # Transaction to store stock from GoogleTrend API to database
    class AddStock
      include Dry::Transaction

      step :find_stock
      step :store_stock

      private

      DB_ERR_MSG = 'Having trouble accessing the database'
      GH_NOT_FOUND_MSG = 'Could not find that stock on GoogleTrend'

      def find_stock(input)
        if (stock = stock_in_database(input))
          input[:local_stock] = stock
        else
          input[:remote_stock] = stock_from_googletrend(input)
        end
        Success(input)
      rescue StandardError => e
        Failure(Response::ApiResult.new(status: :not_found, message: e.to_s))
      end

      def store_stock(input)
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

      # following are support methods that other services could use

      def stock_from_googletrend(input)
        GoogleTrend::Gt::TrendMapper.new(input['rgt_url'], App.config.RGT_TOKEN).find
      rescue StandardError
        raise GH_NOT_FOUND_MSG
      end

      def stock_in_database(input)
        Repository::For.klass(Entity::RgtEntity)
          .find_stock_name(CGI.unescape(input['rgt_url']))
      end
    end
  end
end
