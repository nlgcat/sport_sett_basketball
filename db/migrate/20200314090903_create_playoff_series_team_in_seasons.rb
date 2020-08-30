Sequel.migration do
  change do
    create_table :playoff_series_team_in_seasons do
      primary_key :id
    end
  end
end
