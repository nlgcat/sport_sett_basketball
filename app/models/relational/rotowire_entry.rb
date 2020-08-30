class RotowireEntry < Sequel::Model
  plugin :timestamps, update_on_create: true
  one_through_one :game
  many_to_one :dataset_split
end
