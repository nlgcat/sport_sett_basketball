Sequel.migration do
  change do
    create_table :discrepancies_team_in_games do
      foreign_key :team_in_game_id, :team_in_games, null: false
      foreign_key :discrepancy_id,  :discrepancies, null: false
      index [:team_in_game_id]
      index [:discrepancy_id]
    end
  end
end
