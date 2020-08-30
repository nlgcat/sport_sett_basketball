class Season < Sequel::Model
  plugin :timestamps, update_on_create: true
  many_to_one :league_structure
  one_to_many :team_in_seasons
  one_to_many :games
  one_to_one  :playoff

  include StatisticConcern

  def all_statistics
    games.map(&:all_statistics).flatten
  end

  def onmt_name
    name
  end

  def name
    "The #{start_year}-#{end_year} season"
  end

  def short_name
    "#{start_year}-#{end_year}"
  end
end
