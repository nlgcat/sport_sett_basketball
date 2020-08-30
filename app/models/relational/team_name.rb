class TeamName < Sequel::Model
  plugin :timestamps, update_on_create: true
  many_to_many :teams
  many_to_many :team_in_seasons

  def self.basketball_reference_override_codes
    {
      'CHO' => 'CHA',
      'PHO' => 'PHX',
      'BRK' => 'BKN',
    }
  end

  def self.bref_to_rotowire_code code
    h = TeamName.basketball_reference_override_codes
    h.keys.include?(code) ? h[code] : code
  end

  def self.rotowire_to_bref_code code
    h = TeamName.basketball_reference_override_codes.invert
    h.keys.include?(code) ? h[code] : code
  end

  def self.get_lookup
    Teamname.map{ |t| [t.code, t] }.to_h
  end

  def to_s
    name
  end

  def self.all_named_entities
    TeamName.map{|place| place.name }
  end
end
