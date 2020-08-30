Sequel.migration do
  change do
    create_table :team_in_playoff_games do
      # Keys
      primary_key :id
      foreign_key :team_in_game_id, :team_in_games,  null: false
      foreign_key :playoff_series_id, :playoff_series,  null: false
      foreign_key :playoff_series_number_id, :playoff_series_numbers,  null: false

      # Data

      # Timestamps
      DateTime  :created_at,  null: false
      DateTime  :updated_at,  null: false

      # Index
      index [:team_in_game_id]
      index [:playoff_series_id]
      index [:playoff_series_number_id]
    end
  end
end
