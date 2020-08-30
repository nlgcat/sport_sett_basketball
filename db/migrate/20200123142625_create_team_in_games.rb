Sequel.migration do
  change do
    create_table :team_in_games do
      # Keys
      primary_key :id
      foreign_key :team_in_season_id, :team_in_seasons,  null: false
      foreign_key :game_id, :games,  null: false

      # Data
      Boolean :winner, null: false
      Boolean :home, null: false
      Integer :points, null: false
      Integer :game_number, null: false, default: 0

      # Timestamps
      DateTime  :created_at, null: false
      DateTime  :updated_at, null: false

      # Index
      index [:winner]
      index [:home]
      index [:points]
      index [:game_number]
      index [:team_in_season_id]
      index [:game_id]
    end
  end
end
