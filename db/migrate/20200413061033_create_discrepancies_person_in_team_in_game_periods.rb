Sequel.migration do
  change do
    create_table :discrepancies_person_in_team_in_game_periods do
      foreign_key :person_in_team_in_game_period_id,  :person_in_team_in_game_periods, null: false
      foreign_key :discrepancy_id,                    :discrepancies,                  null: false
      index [:person_in_team_in_game_period_id]
      index [:discrepancy_id]
    end
  end
end
