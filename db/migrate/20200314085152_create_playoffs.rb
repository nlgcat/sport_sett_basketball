Sequel.migration do
  change do
    create_table :playoffs do
      # Keys
      primary_key :id
      foreign_key :season_id, :seasons,  null: false

      # Data
      DateTime  :playoff_start,   null: false
      DateTime  :playoff_end,     null: false

      # Timestamps
      DateTime  :created_at, null: false
      DateTime  :updated_at, null: false

      # Index
      index [:season_id]
      index [:playoff_start]
      index [:playoff_end]
    end
  end
end
