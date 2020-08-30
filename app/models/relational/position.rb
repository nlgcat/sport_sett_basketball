class Position < Sequel::Model
  plugin :timestamps, update_on_create: true
  many_to_one :role
  many_to_many :people
  many_to_many :person_in_game_positions

  def self.get_lookup
    Position.map{|position| [position.code, position] }.to_h
  end

  def self.all_named_entities
    Position.map{|position| [position.name] }.flatten.reject{|x| x == 'unknown' }
  end
end
