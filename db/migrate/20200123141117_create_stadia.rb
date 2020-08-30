Sequel.migration do
  change do
    create_table :stadia do
      # Keys
      primary_key :id
      foreign_key :place_id, :places,  null: false

      # Data
      String  :name,  null: false
      Integer :capacity, null: false
      Integer :opened, null: false

      # Timestamps
      DateTime  :created_at,  null: false
      DateTime  :updated_at,  null: false

      # Index
      index [:name]
      index [:place_id]
      index [:opened]
    end
  end
end
