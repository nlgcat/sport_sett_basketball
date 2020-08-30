Sequel.migration do
  change do
    create_table :plays_team_in_games do
      foreign_key :team_in_game_id, :team_in_games, null: false
      foreign_key :play_id,         :plays,         null: false
      index [:team_in_game_id]
      index [:play_id]
    end
  end
end
