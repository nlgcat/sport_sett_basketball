Sequel.migration do
  change do
    create_table :places do
      # Keys
      primary_key :id
      foreign_key :place_type_id, :place_types,  null: false

      # Data
      String  :name,  null: false

      # Timestamps
      DateTime  :created_at,  null: false
      DateTime  :updated_at,  null: false

      # Index
      index [:name]
      index [:place_type_id]
    end
  end
end
