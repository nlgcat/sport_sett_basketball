Sequel.migration do
  change do
    create_table :person_in_team_in_game_periods_play_statistics do
      foreign_key :person_in_team_in_game_period_id,  :person_in_team_in_game_periods,  null: false
      foreign_key :play_statistic_id,                 :play_statistics,                 null: false
      index [:person_in_team_in_game_period_id]
      index [:play_statistic_id]
    end
  end
end
