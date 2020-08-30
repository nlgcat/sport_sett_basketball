Sequel.migration do
  change do
    create_table :positions do
      # Keys
      primary_key :id
      foreign_key :role_id, :roles,  null: false

      # Data
      String :name, null: false
      String :code, null: false

      # Timestamps
      DateTime  :created_at, null: false
      DateTime  :updated_at, null: false

      # Index
      index [:role_id]
      index [:name]
      index [:code]
    end
  end
end
