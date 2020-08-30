Sequel.migration do
  change do
    create_table :discrepancies_play_statistic_statistics do
      foreign_key :play_statistic_id, :play_statistics, null: false
      foreign_key :discrepancy_id,    :discrepancies,   null: false
      index [:play_statistic_id]
      index [:discrepancy_id]
    end
  end
end
