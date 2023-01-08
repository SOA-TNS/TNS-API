# frozen_string_literal: true

module GoogleTrend
  module Repository
    # Repository for Project Entities
    class FmFear
      # return an array
      def self.all
        Database::FmFearOrm.all.map { |db_stock| rebuild_entity(db_stock) }
      end

      def self.find_stock_name(time)
        db_stock = Database::FmFearOrm
          .where(time:)
          .first

        rebuild_entity(db_stock)
      end

      def self.find_stock_names(stock_names)
        stock_names.map do |query|
          find_stock_name(query)
        end.compact
      end

      def self.find_id(id)
        db_record = Database::FmFearOrm.first(id:)
        rebuild_entity(db_record)
      end

      def self.create(entity)
        db_stock = Database::FmFearOrm.create(entity.to_attr_hash)
        rebuild_entity(db_stock)
      end

      def self.update(entity)
        db_stock = Database::FmFearOrm.update(entity.to_attr_hash)
        rebuild_entity(db_stock)
      end

      # put into entity
      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::FmFearEntity.new(
          db_record.to_hash.merge(
            time: db_record.to_hash[:time]
          )
        )
      end
    end
  end
end
