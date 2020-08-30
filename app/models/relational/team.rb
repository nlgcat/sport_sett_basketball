class Team < Sequel::Model
  plugin :timestamps, update_on_create: true
  one_through_one :stadium
  many_to_many :people
  many_to_many :places # A sports team can be in two places at once: https://en.wikipedia.org/wiki/New_Orleans_Pelicans
  one_to_many :team_in_seasons
  one_through_one :team_name

  include StatisticConcern

  def all_statistics
    team_in_seasons.map(&:all_statistics).flatten
  end

  def onmt_h
    {
      'TEAM-FULL-NAME'  => "#{place_name} #{name}",
      'TEAM-PLACE'      => place_name,
      'TEAM-NAME'       => name,
      # 'TEAM-CODE'       => code,
    }
  end

  def to_s
    "#{places.map{|p| p.name }.join(' ')} #{team_name}"
  end

  # TODO - can probably refactor
  def self.get_lookup
    h = {}
    Team.each do |team|
      pn = team.places.first.name
      tn = team.team_name.name
      h[pn] = {} unless h[pn]
      h[pn][tn] = team
    end
    h
  end

  def sett_names
    [place_name, name, code]
  end

  def place_name
    places.first.name
  end

  def name
    team_name.name
  end

  def code
    team_name.code
  end
end
