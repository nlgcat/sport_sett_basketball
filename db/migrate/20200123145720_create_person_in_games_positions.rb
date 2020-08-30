Sequel.migration do
  change do
    create_table :person_in_team_in_games_positions do
      foreign_key :person_in_team_in_game_id, :person_in_team_in_games, null: false
      foreign_key :position_id,               :positions,               null: false
      index [:person_in_team_in_game_id]
      index [:position_id]
    end
  end
end
