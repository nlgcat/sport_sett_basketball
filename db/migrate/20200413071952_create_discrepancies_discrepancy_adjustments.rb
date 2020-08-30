Sequel.migration do
  change do
    create_table :discrepancies_discrepancy_adjustments do
      foreign_key :discrepancy_adjustment_id, :discrepancy_adjustments,    null: false
      foreign_key :discrepancy_id,            :discrepancies, null: false
      index [:discrepancy_adjustment_id, :discrepancy_id]
    end
  end
end
