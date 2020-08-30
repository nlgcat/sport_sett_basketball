Sequel.migration do
  change do
    create_table :statistics_team_in_game_periods do
      foreign_key :team_in_game_period_id,  :team_in_game_periods, null: false
      foreign_key :statistic_id,            :statistics,            null: false
      index [:team_in_game_period_id]
      index [:statistic_id]
    end
  end
end
