Sequel.migration do
  change do
    create_table :leagues do
      # Keys
      primary_key :id
      foreign_key :sport_id, :sports, null: false

      # Data
      String  :name,        null: false
      String  :abreviation, null: false
      String  :determiner,  null: false, default: true

      # Timestamps
      DateTime  :created_at,  null: false
      DateTime  :updated_at,  null: false

      # Index
      index [:sport_id]
      index [:name]
      index [:abreviation]
    end
  end
end
