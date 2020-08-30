Sequel.migration do
  change do
    create_table :statistic_types do
      # Keys
      primary_key :id

      # Data
      String  :name,  null: false
      String  :code,  null: false
      Boolean :counts_for_double, null: false, default: false
      Integer :points_per, null: false, default: 0
      Integer :multiplier, null: false, default: 1

      # Timestamps
      DateTime  :created_at,  null: false
      DateTime  :updated_at,  null: false

      # Index
      index [:name]
      index [:code]
      index [:counts_for_double]
      index [:points_per]
      index [:multiplier]
    end
  end
end
