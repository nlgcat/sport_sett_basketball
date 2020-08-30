Sequel.migration do
  change do
    create_table :statistics do
      # Keys
      primary_key :id
      foreign_key :statistic_type_id, :statistic_types,  null: false

      # Data
      Integer :quantity, null: false

      # Timestamps
      DateTime  :created_at,  null: false
      DateTime  :updated_at,  null: false

      # Index
      index [:statistic_type_id]
      index [:quantity]
    end
  end
end
