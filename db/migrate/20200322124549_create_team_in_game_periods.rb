Sequel.migration do
  change do
    create_table :team_in_game_periods do
      # Keys
      primary_key :id
      foreign_key :game_period_id,  :game_periods,  null: false
      foreign_key :team_in_game_id, :team_in_games, null: false

      # Data

      # Timestamps
      DateTime  :created_at, null: false
      DateTime  :updated_at, null: false

      # Index
      index [:game_period_id]
      index [:team_in_game_id]
    end
  end
end
