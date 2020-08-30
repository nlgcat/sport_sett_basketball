Sequel.migration do
  change do
    create_table :seasons do
      # Keys
      primary_key :id
      foreign_key :league_structure_id, :league_structures,  null: false

      # Data
      Integer   :start_year,      null: false
      Integer   :end_year,        null: false
      DateTime  :season_start,    null: false
      DateTime  :season_end,      null: false

      # Timestamps
      DateTime  :created_at, null: false
      DateTime  :updated_at, null: false

      # Index
      index [:league_structure_id]
      index [:season_start]
      index [:season_end]
      index [:start_year]
      index [:end_year]
    end
  end
end
