Sequel.migration do
  change do
    create_table :league_structures do
      # Keys
      primary_key :id
      foreign_key :league_id,             :leagues,         null: false

      # Data

      # Timestamps
      DateTime  :created_at, null: false
      DateTime  :updated_at, null: false

      # Index
      index [:league_id]
    end
  end
end