Sequel.migration do
  change do
    create_table :person_in_team_in_games do
      # Keys
      primary_key :id
      foreign_key :person_in_team_in_season_id, :person_in_team_in_seasons, null: false
      foreign_key :team_in_game_id,             :team_in_games,             null: false

      # Data
      Boolean :starter, null: false, default: false

      # Timestamps
      DateTime  :created_at, null: false
      DateTime  :updated_at, null: false

      # Index
      index [:person_in_team_in_season_id]
      index [:team_in_game_id]
    end
  end
end
