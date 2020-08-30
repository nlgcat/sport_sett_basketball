class Stadium < Sequel::Model
  plugin :timestamps, update_on_create: true
  many_to_many :games
  many_to_many :team_in_seasons
  many_to_many :teams
  many_to_one  :place

  def to_s
    name
  end

  def sett_names
    [name] + place.sett_names
  end

  def onmt_h
    {
      'STADIUM'       => name,
      'CAPACITY'      => capacity.round(-2)
    }.merge(place.onmt_h)
  end

  def onmt_name
    name
  end

  def self.all_named_entities
    Stadium.map{|stadium| stadium.name }
  end

  def self.get_lookup
    Stadium.map{ |s| [s.name, s] }.to_h
  end
end
