Sequel.migration do
  change do
    create_table :stadia_team_in_seasons do
      foreign_key :stadium_id,        :stadia,          null: false
      foreign_key :team_in_season_id, :team_in_seasons, null: false
      index [:stadium_id]
      index [:team_in_season_id]
    end
  end
end
