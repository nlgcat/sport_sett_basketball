class TeamInSeason < Sequel::Model
  plugin :timestamps, update_on_create: true
  one_through_one :place
  one_through_one :stadium
  many_to_one :division_structure
  many_to_one :season
  many_to_one :team
  one_to_many :person_in_team_in_season
  one_to_many :team_in_games
  one_through_one :team_name

  include StatisticConcern

  def all_statistics
    team_in_games.map(&:all_statistics).flatten
  end

  def name
    "#{team_name.determiner ? 'The ' : nil}#{season.short_name} #{place} #{team_name}"
  end 

  def to_s
    "#{team_name.determiner ? 'The ' : nil}#{season.start_year}-#{(season.start_year+1).to_s.last(2)} #{place} #{team_name}"
  end

  # TODO - Refactor
  def self.get_lookup
    h = {}
    TeamInSeason.each do |tis|
      pn = tis.place.name
      tn = tis.team_name.name
      h[pn] = {} unless h[pn]
      h[pn][tn] = {} unless h[pn][tn]
      h[pn][tn][tis.season_id] = tis
    end
    h
  end
end
