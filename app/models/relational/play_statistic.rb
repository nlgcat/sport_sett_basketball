class PlayStatistic < Sequel::Model
  plugin :timestamps, update_on_create: true

  many_to_one :play
  many_to_one :statistic
  one_to_many :play_statistic_reasons
  one_through_one :person_in_team_in_game_period
  one_through_one :team_in_game_period

  include StatisticConcern

  def all_statistics
    [statistic]
  end
end
