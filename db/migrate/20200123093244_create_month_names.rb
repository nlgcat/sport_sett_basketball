Sequel.migration do
  change do
    create_table :month_names do
      # Keys
      primary_key :id

      # Data
      String    :name,                null: false
      Integer   :calander_month_int,  null: false
      Integer   :year_offset,         null: false

      # Timestamps
      DateTime  :created_at,  null: false
      DateTime  :updated_at,  null: false

      # Index
      index [:name]
      index [:calander_month_int]
      index [:year_offset]
    end
  end
end
