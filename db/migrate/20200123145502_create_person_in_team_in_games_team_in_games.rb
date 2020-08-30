Sequel.migration do
  change do
    create_table :person_in_team_in_games_team_in_games do
      foreign_key :person_in_team_in_game_id, :person_in_team_in_games,   null: false
      foreign_key :team_in_game_id,           :team_in_games,             null: false
      index [:person_in_team_in_game_id]
      index [:team_in_game_id]
    end
  end
end
