Sequel.migration do
  change do
    create_table :people do
      # Keys
      primary_key :id

      # Data
      String :name,         null: false, unique: true
      String :first_name,   null: true
      String :last_name,    null: true
      String :url_seg,      null: false

      # Timestamps
      DateTime  :created_at, null: false
      DateTime  :updated_at, null: false

      # Index
      index [:name]
      index [:first_name]
      index [:last_name]
      index [:url_seg], unique: true
    end
  end
end
