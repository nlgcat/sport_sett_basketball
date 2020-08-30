Sequel.migration do
  change do
    create_table :team_in_seasons_team_names do
      foreign_key :team_in_season_id, :team_in_seasons, null: false
      foreign_key :team_name_id,      :team_names,      null: false
      index [:team_in_season_id]
      index [:team_name_id]
    end
  end
end
