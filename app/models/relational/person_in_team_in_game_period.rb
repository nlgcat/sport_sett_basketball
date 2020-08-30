class PersonInTeamInGamePeriod < Sequel::Model
  plugin :timestamps, update_on_create: true
  many_to_one :person_in_team_in_game
  many_to_one :team_in_game_period
  many_to_many :statistics
  many_to_many :play_statistics

  include StatisticConcern

  def all_statistics
    statistics
  end

  def onmt_h tense=:PAST
    person.onmt_h.merge(statistics_h)
  end

  def onmt_name
    person_in_team_in_game.person.name
  end

  def omnt_entity_name
    person.url_seg
  end

  def dimensions
    {
      ENTITY: person,
      EVENT:  team_in_game_period,
    }
  end

  def all_play_statistics
    play_statistics.map(&:statistic)
  end

  def person
    person_in_team_in_game.person
  end

  def name
    "#{person_in_team_in_game.name} in the #{game_period.value.ordinalize} period"
  end

  def game_period
    team_in_game_period.game_period
  end

  def team_in_game
    team_in_game_period.team_in_game
  end
end
