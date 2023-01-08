# frozen_string_literal: true

module GoogleTrend
  module Repository
    # Repository for Project Entities
    class FmNews
      # return an array
      def self.all
        Database::FmNewsOrm.all.map { |db_stock| rebuild_entity(db_stock) }
      end

      def self.find_stock_name(stock_name)
        db_stock = Database::FmNewsOrm
          .where(stock_name:)
          .first

        rebuild_entity(db_stock)
      end

      def self.find_stock_names(stock_names)
        stock_names.map do |query|
          find_stock_name(query)
        end.compact
      end

      def self.find_id(id)
        db_record = Database::FmNewsOrm.first(id:)
        rebuild_entity(db_record)
      end

      def self.create(entity)
        db_stock = Database::FmNewsOrm.create(entity.to_attr_hash)
        rebuild_entity(db_stock)
      end

      def self.update(entity)
        db_stock = Database::FmNewsOrm.update(entity.to_attr_hash)
        rebuild_entity(db_stock)
      end

      # put into entity
      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::FmNewsEntity.new(
          db_record.to_hash.merge(
            query: db_record.to_hash[:query]
          )
        )
      end
    end
  end
end
