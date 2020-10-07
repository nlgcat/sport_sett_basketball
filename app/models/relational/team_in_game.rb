class TeamInGame < Sequel::Model
  plugin :timestamps, update_on_create: true
  many_to_one :game
  many_to_one :team_in_season
  many_to_many :statistics
  one_to_many :person_in_team_in_games
  one_to_many :team_in_game_periods
  many_to_many :discrepancies

  include StatisticConcern

  def all_statistics
    # person_in_team_in_games.map(&:all_statistics).flatten
    statistics
  end

  def onmt_h tense=:PAST
    arr = [team.onmt_h, is_home_h]
    arr << statistics_h if tense == :PAST
    arr << record_h if tense == :PAST
    # arr << next_opponent_h if tense == :FUTURE
    arr.inject(&:merge)
  end

  def onmt_name
    "#{team_in_season.place} #{team_in_season.team_name}"
  end

  def is_home_h
    {IS_HOME: "#{home}"}
  end

  def rotowire_json_line
    s_h = self.statistics_h
    r_h = self.record_h
    tigp_h = self.team_in_game_period_lookup

    h = {
      "TEAM-PTS_QTR2" => tigp_h[2].statistics_h['PTS'],
      "TEAM-FT_PCT"   => s_h['FT_PCT'],
      "TEAM-PTS_QTR1" => tigp_h[1].statistics_h['PTS'],
      "TEAM-PTS_QTR4" => tigp_h[4].statistics_h['PTS'],
      "TEAM-PTS_QTR3" => tigp_h[3].statistics_h['PTS'],
      "TEAM-CITY"     => self.team_place_name,
      "TEAM-PTS"      => s_h['PTS'],
      "TEAM-AST"      => s_h['AST'],
      "TEAM-LOSSES"   => r_h[:LOSSES],
      "TEAM-NAME"     => self.team_name,
      "TEAM-WINS"     => r_h[:WINS],
      "TEAM-REB"      => s_h['REB'],
      "TEAM-TOV"      => s_h['TOV'],
      "TEAM-FG3_PCT"  => s_h['FG3_PCT'],
      "TEAM-FG_PCT"   => s_h['FG_PCT']
    }
  end

  def next_game
    next_tig = TeamInGame.find(team_in_season_id: team_in_season.id, game_number: game_number+1)
    next_tig ? NextGame[next_tig.game.id] : nil
  end

  def opponent
    game.team_in_games.reject{|tig| tig == self}.first
  end

  def date
    game.date
  end

  def opponent
    game.team_in_games.reject{|tig| tig == self }.first
  end

  def previous_tigs after_game=true
    if after_game
      team_in_season.team_in_games.select{|tig| tig.game_number <= game_number }.reverse
    else
      team_in_season.team_in_games.select{|tig| tig.game_number < game_number }.reverse
    end
  end

  # Record after the game
  def record_h after_game=true
    pre_tigs = previous_tigs
    last_result = pre_tigs.size > 0 ? pre_tigs.first.winner : nil
    streak = 0
    pre_tigs.each do |pre_tig|
      break if pre_tig.winner != last_result
      streak += 1
    end
    h = {
      WINS:   pre_tigs.select{|tig| tig.winner }.size,
      LOSSES: pre_tigs.select{|tig| !tig.winner }.size,
      STREAK: pre_tigs.size > 0 ? ((last_result ? 'W' : 'L') + streak.to_s) : 0,
      WINNER: winner,
    }
  end

  def omnt_entity_name
    team.code
  end

  def dimensions
    {
      ENTITY: team_in_season,
      EVENT:  game,
    }
  end

  def to_s
    team_in_season.team.to_s
  end

  def all_person_in_team_in_game_statistics
    person_in_team_in_games.map{|pitig| pitig.all_statistics }.flatten
  end

  # TODO - consolodate these with other classes
  def find_discrepancies
    StatisticType.each do |statistic_type|
      next if ['DF', 'VIO', 'REB', 'PTS', 'MIN', 'SEC', '+/-'].include? statistic_type.code
      stats = {
        tig:    all_statistics.select{|s| s.statistic_type_id == statistic_type.id },
        pitig:  all_person_in_team_in_game_statistics.select{|s| s.statistic_type_id == statistic_type.id },
      }

      totals = stats.map{|k,v| [k,v.map(&:quantity).sum] }.to_h
      raise "Too many statistics for tig" if stats[:tig].size > 1
      if totals[:tig] != totals[:pitig]

        # TODO - Cleaner way to handle this
        # - This should resolve the cases where there is no statistic but should be one
        if stats[:tig].size ==  0
          s = Statistic.create(quantity: 0, statistic_type_id: statistic_type.id)
          stats[:tig] = [s]
          self.add_statistic s
        end


        adjustment  = DiscrepancyAdjustment.create(quantity: totals[:tig], quantity_should_be: totals[:pitig])
        discrepancy = TeamInGameDiscrepancy.create
        discrepancy.statistic = stats[:tig].first
        discrepancy.discrepancy_adjustment = adjustment
        discrepancy.team_in_game = self
        puts " #{statistic_type.code} #{totals[:tig]} == #{totals[:pitig]}"
      end
    end
  end

  # TODO - could be refactored
  def self.get_lookup
    h = {}
    TeamInGame.each do |tig|
      h[tig.game_id] = {} unless h[tig.game_id] 
      h[tig.game_id][tig.team_in_season_id] = tig unless h[tig.game_id][tig.team_in_season_id]
    end
    h
  end

  def team_in_game_period_lookup key=:value
    team_in_game_periods.map{|tigp| [tigp.game_period.send(key), tigp] }.to_h
  end

  def person_in_team_in_game_period_lookup key=:url_seg
    person_in_team_in_games.map{|pitig| [pitig.person.send(key), pitig.person_in_team_in_game_period_lookup(:value)] }.to_h
  end

  def person_in_team_in_game_lookup person_key=:url_seg
    team_in_game_periods.map{|tigp| [tigp.game_period.value, tigp] }.to_h
  end

  def sett_names
    arr = team.sett_names
    arr += game.sett_names if home
    arr
  end

  def name
    team.name
  end

  def team
    team_in_season.team
  end

  def code
    team_in_season.team.team_name.code
  end

  def name
    team_in_season.team.team_name.name
  end

  # TODO - this should return the TeamName object (but find where it is called)
  #      - Ambiguous terminology, having a TeamName object, with a name attribute
  def team_name
    team_in_season.team.team_name.name
  end

  def team_place_name
    team_in_season.team.places.first.name
  end
end