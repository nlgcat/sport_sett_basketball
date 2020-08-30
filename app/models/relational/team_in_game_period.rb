class TeamInGamePeriod < Sequel::Model
  plugin :timestamps, update_on_create: true
  many_to_one :team_in_game
  many_to_one :game_period
  many_to_many :statistics
  one_to_many :person_in_team_in_game_periods
  many_to_many :statistics
  many_to_many :play_statistics

  include StatisticConcern

  def all_statistics
    person_in_team_in_game_periods.map(&:all_statistics).flatten
  end

  def onmt_h tense=:PAST
    h = [statistics_h, leads_h].inject(&:merge)
  end

  def leads_h
    scores = Game.cached_team_period_scores team_in_game.game.id

    current_period = game_period.value
    before_scores  = scores.select{|period, data| period <= current_period }
    after_scores  = scores.select{|period, data| period <= current_period }

    team_code = code

    points_before = {current: 0, opponent: 0}
    points_after = {current: 0, opponent: 0}

    after_scores.each do |period, data|
      data.each do |c, value|
        k = code == c ? :current : :opponent
        points_before[k] += value.to_i unless period == current_period
        points_after[k]  += value.to_i 
      end
    end

    had_lead_diff = points_before[:current] - points_before[:opponent]
    has_lead_diff = points_after[:current] - points_after[:opponent]

    h = {
      'HAD_LEAD' => (had_lead_diff == 0 ? 'TIE' : (had_lead_diff > 0 ? 'YES' : 'NO')),
      'HAS_LEAD' => (has_lead_diff == 0 ? 'TIE' : (has_lead_diff > 0 ? 'YES' : 'NO')),
    }
  end

  def onmt_name
    team_in_game.onmt_name
  end

  def omnt_entity_name
    team.code
  end

  def dimensions
    {
      ENTITY: team_in_game,
      EVENT:  game_period,
    }
  end

  def code
    team.code
  end

  def team
    team_in_game.team
  end

  def name
    team_in_game.name
  end
end
