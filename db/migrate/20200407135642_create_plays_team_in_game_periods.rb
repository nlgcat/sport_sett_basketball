Sequel.migration do
  change do
    create_table :play_statistics_team_in_game_periods do
      foreign_key :team_in_game_period_id,  :person_in_team_in_game_periods,  null: false
      foreign_key :play_statistic_id,       :play_statistics,                 null: false
      index [:team_in_game_period_id]
      index [:play_statistic_id]
    end
  end
end
