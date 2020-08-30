Sequel.migration do
  change do
    create_table :games_rotowire_entries do
      foreign_key :game_id,             :games,             null: false
      foreign_key :rotowire_entry_id,   :rotowire_entries,  null: false
      index [:game_id]
      index [:rotowire_entry_id]
    end
  end
end
