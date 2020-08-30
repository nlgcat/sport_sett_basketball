Sequel.migration do
  change do
    create_table :discrepancies do
      # Keys
      primary_key :id
      
      # CTI
      String  :cti_type,            null: false

      # Data
      Boolean :resolved,            null: false, default: false

      # Timestamps
      DateTime  :created_at, null: false
      DateTime  :updated_at, null: false

      # Index
      index [:resolved]
    end
  end
end
