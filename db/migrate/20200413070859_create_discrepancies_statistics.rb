Sequel.migration do
  change do
    create_table :discrepancies_statistics do
      foreign_key :statistic_id,    :statistics,    null: false
      foreign_key :discrepancy_id,  :discrepancies, null: false
      index [:statistic_id, :discrepancy_id]
    end
  end
end
