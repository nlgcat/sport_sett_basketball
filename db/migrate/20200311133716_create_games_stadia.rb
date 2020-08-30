Sequel.migration do
  change do
    create_table :games_stadia do
      foreign_key :stadium_id,  :stadia,  null: false
      foreign_key :game_id,     :games,   null: false
      index [:stadium_id]
      index [:game_id]
    end
  end
end
