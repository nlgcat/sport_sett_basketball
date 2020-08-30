Sequel.migration do
  change do
    create_table :places_team_in_seasons do
      foreign_key :place_id,          :places,          null: false
      foreign_key :team_in_season_id, :team_in_seasons, null: false
      index [:place_id]
      index [:team_in_season_id]
    end
  end
end
