Sequel.migration do
  change do
    create_table :rotowire_entries do
      # Keys
      primary_key :id
      foreign_key :dataset_split_id, :dataset_splits,  null: false

      # Data
      String   :summary, null: false, default: ""
      Integer  :rw_line, null: false, default: -1

      # Timestamps
      DateTime  :created_at, null: false
      DateTime  :updated_at, null: false

      # Index
      index [:rw_line]
      index [:dataset_split_id]
    end
  end
end
