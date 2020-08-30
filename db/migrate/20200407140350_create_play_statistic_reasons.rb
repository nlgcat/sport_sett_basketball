Sequel.migration do
  change do
    create_table :play_statistic_reasons do
      # Keys
      primary_key :id
      foreign_key :play_statistic_id,             :play_statistics,             null: false
      foreign_key :play_statistic_reason_type_id, :play_statistic_reason_types, null: false

      # Data

      # Timestamps
      DateTime  :created_at, null: false
      DateTime  :updated_at, null: false

      # Index
      index [:play_statistic_id]
      index [:play_statistic_reason_type_id]
    end
  end
end
