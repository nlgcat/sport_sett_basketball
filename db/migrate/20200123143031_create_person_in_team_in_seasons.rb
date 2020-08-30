Sequel.migration do
  change do
    create_table :person_in_team_in_seasons do
      # Keys
      primary_key :id
      foreign_key :team_in_season_id, :team_in_seasons,  null: false
      foreign_key :person_id, :people,  null: false

      # Data

      # Timestamps
      DateTime  :created_at, null: false
      DateTime  :updated_at, null: false

      # Index
      index [:team_in_season_id]
      index [:person_id]
    end
  end
end
