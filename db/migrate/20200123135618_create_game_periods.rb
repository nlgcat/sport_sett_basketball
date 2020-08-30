Sequel.migration do
  change do
    create_table :game_periods do
      # Keys
      primary_key :id
      foreign_key :game_id, :games,  null: false

      # Data
      Integer :value, null: false

      # Timestamps
      DateTime  :created_at, null: false
      DateTime  :updated_at, null: false

      # Index
      index [:game_id]
      index [:value]
    end
  end
end
