Sequel.migration do
  change do
    create_table :team_names do
      # Keys
      primary_key :id

      # Data
      String  :name,        null: false
      String  :code,        null: false
      Boolean :determiner,  null: false, default: true

      # Timestamps
      DateTime  :created_at,  null: false
      DateTime  :updated_at,  null: false

      # Index
      index [:name]
      index [:code]
      index [:determiner]
    end
  end
end
