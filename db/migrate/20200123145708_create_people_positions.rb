Sequel.migration do
  change do
    create_table :people_positions do
      foreign_key :person_id,   :people,      null: false
      foreign_key :position_id, :positions,   null: false
      index [:person_id]
      index [:position_id]
    end
  end
end
