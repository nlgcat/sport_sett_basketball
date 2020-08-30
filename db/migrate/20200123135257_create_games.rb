Sequel.migration do
  change do
    create_table :games do
      # Keys
      primary_key :id
      foreign_key :season_id, :seasons,  null: false
      foreign_key :month_name_id,  :month_names,  null: false

      # Data
      Integer  :day_of_month, null: false
      DateTime :date, null: false

      Integer  :attendance, null: false, default: 0

      # TODO - handle this properly
      Integer  :stage, null: false, default: -1

      # Timestamps
      DateTime  :created_at, null: false
      DateTime  :updated_at, null: false

      # Index
      index [:season_id]
      index [:day_of_month]
      index [:month_name_id]
      index [:attendance]
      index [:stage]
    end
  end
end
