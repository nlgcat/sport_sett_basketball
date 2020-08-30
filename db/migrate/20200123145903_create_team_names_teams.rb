Sequel.migration do
  change do
    create_table :team_names_teams do
      foreign_key :team_id,       :teams,       null: false
      foreign_key :team_name_id,  :team_names,  null: false
      index [:team_id]
      index [:team_name_id]
    end
  end
end
