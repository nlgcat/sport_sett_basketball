Sequel.migration do
  change do
    create_table :person_in_team_in_game_periods_statistics do
      foreign_key :person_in_team_in_game_period_id,  :person_in_team_in_game_periods,  null: false
      foreign_key :statistic_id,                      :statistics,                      null: false
      index [:person_in_team_in_game_period_id]
      index [:statistic_id]
    end
  end
end
