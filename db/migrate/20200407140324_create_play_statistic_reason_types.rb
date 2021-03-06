Sequel.migration do
  change do
    create_table :play_statistic_reason_types do
      # Keys
      primary_key :id

      # Data
      String    :name,        null: false

      # Timestamps
      DateTime  :created_at,  null: false
      DateTime  :updated_at,  null: false

      # Index
      index [:name]
    end
  end
end
