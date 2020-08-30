Sequel.migration do
  change do
    create_table :discrepancy_adjustments do
      # Keys
      primary_key :id

      # Data
      Integer :quantity,            null: false
      Integer :quantity_should_be,  null: false

      # Timestamps
      DateTime  :created_at, null: false
      DateTime  :updated_at, null: false

      # Index
      index [:quantity]
      index [:quantity_should_be]
    end
  end
end
