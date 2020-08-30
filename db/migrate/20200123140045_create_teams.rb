Sequel.migration do
  change do
    create_table :teams do
      # Keys
      primary_key :id

      # Data

      # Timestamps
      DateTime  :created_at, null: false
      DateTime  :updated_at, null: false

      # Index
    end
  end
end
