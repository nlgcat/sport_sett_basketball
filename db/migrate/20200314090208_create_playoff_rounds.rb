Sequel.migration do
  change do
    create_table :playoff_rounds do
      # Keys
      primary_key :id
      foreign_key :playoff_id, :playoffs,  null: false
      foreign_key :playoff_round_type_id, :playoff_round_types,  null: false

      # Data

      # Timestamps
      DateTime  :created_at,  null: false
      DateTime  :updated_at,  null: false

      # Index
      index [:playoff_id]
      index [:playoff_round_type_id]
    end
  end
end
