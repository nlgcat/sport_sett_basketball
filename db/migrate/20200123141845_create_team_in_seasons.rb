Sequel.migration do
  change do
    create_table :team_in_seasons do
      # Keys
      primary_key :id
      foreign_key :division_structure_id, :division_structures,  null: false
      foreign_key :season_id, :seasons,  null: false
      foreign_key :team_id, :teams,  null: false

      # Data

      # Timestamps
      DateTime  :created_at, null: false
      DateTime  :updated_at, null: false

      # Index
      index [:division_structure_id]
      index [:season_id]
      index [:team_id]
    end
  end
end
