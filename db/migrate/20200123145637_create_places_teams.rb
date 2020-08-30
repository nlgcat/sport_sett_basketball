Sequel.migration do
  change do
    create_table :places_teams do
      foreign_key :place_id,        :places,          null: false
      foreign_key :team_id,         :teams,           null: false
      index [:place_id]
      index [:team_id]
    end
  end
end
