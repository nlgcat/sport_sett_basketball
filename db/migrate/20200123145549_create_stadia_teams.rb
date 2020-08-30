Sequel.migration do
  change do
    create_table :stadia_teams do
      foreign_key :stadium_id,  :stadia,        null: false
      foreign_key :team_id,     :teams,         null: false
      index [:stadium_id]
      index [:team_id]
    end
  end
end
