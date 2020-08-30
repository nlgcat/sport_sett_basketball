class League < Sequel::Model
  plugin :timestamps, update_on_create: true
  many_to_one :sport
  one_to_many :conferences
  one_to_many :divisions
  one_to_many :league_structures
end
