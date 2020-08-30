Sequel.migration do
  change do
    create_table :discrepancies_person_in_team_in_games do
      foreign_key :person_in_team_in_game_id, :person_in_team_in_games, null: false
      foreign_key :discrepancy_id,            :discrepancies,           null: false
      index [:person_in_team_in_game_id]
      index [:discrepancy_id]
    end
  end
end
