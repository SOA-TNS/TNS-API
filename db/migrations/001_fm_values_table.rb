# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:fmvalues) do
      primary_key :id

      String :stock_name
      DateTime :created_at
      DateTime :updated_at
    end
  end
end