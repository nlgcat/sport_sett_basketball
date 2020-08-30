class PersonInTeamInSeason < Sequel::Model
  plugin :timestamps, update_on_create: true
  many_to_one :person
  many_to_one :team_in_season
  one_to_many :person_in_team_in_games

  include StatisticConcern

  def all_statistics
    person_in_team_in_games.map(&:all_statistics).flatten
  end

  def name
    person.name
  end

  def first_name
    person.first_name
  end

  def last_name
    person.last_name
  end
end
