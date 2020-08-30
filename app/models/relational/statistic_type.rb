class StatisticType < Sequel::Model
  plugin :timestamps, update_on_create: true
  one_to_many :statistics

  @statistic_code_cache = nil

  def self.statistic_h
    self.all.map{ |st| [st.code, 0] }.to_h
  end

  def self.all_named_entities
    # Doubles are a derived statistic https://en.wikipedia.org/wiki/Double_dribble
    # TODO - other derived statistics to be cleanly handled
    ['double'] + StatisticType.map{ |st| st.name.downcase }.map{ |n| [n, n.pluralize] }.flatten
  end

  def self.from_code code
    StatisticType[StatisticType.id_from_code(code)]
  end

  def self.id_from_code code
    if @statistic_code_cache == nil
      @statistic_code_cache = self.all.map{ |st| [st.code, st.id] }.to_h
    end
    @statistic_code_cache[code]
  end

  # Convert Basketball Reference stat codes to Rotowire ones.
  def self.box_score_convert
    {
      # 'reason' (did not play, injury etc)
      'mp'    => 'SEC',
      'fg'    => 'FGM',
      'fga'   => 'FGA',
      'fg3'   => 'FG3M',
      'fg3a'  => 'FG3A',
      'ft'    => 'FTM',
      'fta'   => 'FTA',
      'orb'   => 'OREB',
      'drb'   => 'DREB',
      'ast'   => 'AST',
      'stl'   => 'STL',
      'blk'   => 'BLK',
      'tov'   => 'TOV',
      'pf'    => 'PF',
      # 'pts'   => 'PTS',
      'plus_minus' => '+/-'
      # Violation is only in play-by-play
      # Drawn Foul is only in play-by-play
      # Tech Foul is only in play-by-play
    }
  end

  def self.get_lookup
    StatisticType.map{ |s| [s.code, s] }.to_h
  end
end
