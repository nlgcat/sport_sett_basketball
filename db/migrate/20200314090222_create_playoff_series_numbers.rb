Sequel.migration do
  change do
    create_table :playoff_series_numbers do
      # Keys
      Integer :id, null: false

      # Data

      # Timestamps
      DateTime  :created_at,  null: false
      DateTime  :updated_at,  null: false

      # Index
      primary_key [:id]
    end
  end
end
