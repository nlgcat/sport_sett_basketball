class Statistic < Sequel::Model
  plugin :timestamps, update_on_create: true
  many_to_one :statistic_type
  one_through_one :person_in_team_in_game_period
  one_to_one :play_statistic

  def code
    statistic_type.code
  end
end
