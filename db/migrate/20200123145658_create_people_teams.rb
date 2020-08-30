Sequel.migration do
  change do
    create_table :people_teams do
      foreign_key :person_id, :people,  null: false
      foreign_key :team_id,   :teams,   null: false
      index [:person_id]
      index [:team_id]
    end
  end
end
