Sequel.migration do
  change do
    create_table :conferences do
      # Keys
      primary_key :id
      foreign_key :league_id, :leagues, null: false

      # Data
      String  :name,  null: false

      # Timestamps
      DateTime  :created_at,  null: false
      DateTime  :updated_at,  null: false

      # Index
      index [:league_id]
      index [:name]
    end
  end
end
