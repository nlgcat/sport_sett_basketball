Sequel.migration do
  change do
    create_table :plays do
      # Keys
      primary_key :id
      foreign_key :game_period_id,  :game_periods,  null: false

      # Data
      Float   :time_seconds,              null: false
      Integer :home_score,                null: false, default: 0
      Integer :home_cumulative_score,     null: false, default: 0
      Integer :visiting_score,            null: false, default: 0
      Integer :visiting_cumulative_score, null: false, default: 0

      # Timestamps
      DateTime  :created_at, null: false
      DateTime  :updated_at, null: false

      # Index
      index [:game_period_id]
      index [:time_seconds]
      index [:home_score]
      index [:home_cumulative_score]
      index [:visiting_score]
      index [:visiting_cumulative_score]
    end
  end
end
