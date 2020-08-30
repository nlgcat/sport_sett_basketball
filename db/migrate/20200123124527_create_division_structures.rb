Sequel.migration do
  change do
    create_table :division_structures do
      # Keys
      primary_key :id
      foreign_key :conference_id,       :conferences,       null: false
      foreign_key :division_id,         :divisions,         null: false
      foreign_key :league_structure_id, :league_structures,  null: false

      # Data

      # Timestamps
      DateTime  :created_at, null: false
      DateTime  :updated_at, null: false

      # Index
      index [:conference_id]
      index [:division_id]
      index [:league_structure_id]
    end
  end
end
