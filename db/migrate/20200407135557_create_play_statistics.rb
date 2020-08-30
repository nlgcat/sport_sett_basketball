Sequel.migration do
  change do
    create_table :play_statistics do
      # Keys
      primary_key :id
      foreign_key :play_id,       :plays,       null: false
      foreign_key :statistic_id,  :statistics,  null: false

      # Data
      Integer :x, null: false, default: 0

      # Timestamps
      DateTime  :created_at, null: false
      DateTime  :updated_at, null: false

      # Index
      index [:play_id]
      index [:statistic_id]
      index [:x]
    end
  end
end
