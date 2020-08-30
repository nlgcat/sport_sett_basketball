Sequel.migration do
  change do
    create_table :person_in_team_in_game_periods do
      # Keys
      primary_key :id
      foreign_key :person_in_team_in_game_id, :person_in_team_in_games, null: false
      foreign_key :team_in_game_period_id,    :team_in_game_periods,    null: false

      # Data

      # Timestamps
      DateTime  :created_at, null: false
      DateTime  :updated_at, null: false

      # Index
      index [:team_in_game_period_id]
      index [:person_in_team_in_game_id]
    end
  end
end
