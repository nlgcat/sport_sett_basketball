Sequel.migration do
  change do
    create_table :playoff_series do
      # Keys
      primary_key :id
      foreign_key :playoff_round_id, :playoff_rounds,  null: false

      # Data

      # Timestamps
      DateTime  :created_at,  null: false
      DateTime  :updated_at,  null: false

      # Index
      index [:playoff_round_id]
    end
  end
end
