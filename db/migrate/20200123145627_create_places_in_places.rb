Sequel.migration do
  change do
    create_table :places_in_places do
      foreign_key :parent_id, :places, null: false
      foreign_key :child_id,  :places, null: false
      index [:parent_id]
      index [:child_id]
    end
  end
end
