module StatisticConcern
  extend ActiveSupport::Concern

  # TODO 
  def resolvable_statistics
    diffs = discrepancies.map{|d| d.code_diff }
  end

  def get_statistic_by_type statistic_type
    all_statistics.select{ |s| s.statistic_type_id == statistic_type.id }.first
  end

  def all_statistics
    []
  end

  def relation_statistics relation
    Array(self.send(relation)).map(&:all_statistics).flatten
  end

  # TODO - this with a map or something
  def countable_statistics_h statistics_arr
    h = {}
    statistics_arr.each do |s|
      code = s.code
      h[code] = h.has_key?(code) ? h[code] + s.quantity.to_i : s.quantity.to_i
    end
    h
  end

  def statistics_h
    aggregate_statistics(countable_statistics_h(all_statistics))
  end

  def onmt_h
    statistics_h 
  end

  def onmt_name

  end

  # Take code => quantity hash
  def aggregate_statistics(input_statistics_h, base_stats=StatisticType.statistic_h)
    stats = base_stats.clone
    # TODO - Must be a cleaner way to add to Hash
    input_statistics_h.each { |code, quantity| stats[code] += quantity }
    throw_percent(stats).each { |k,v| stats[k] = v ? v : 'N/A' }
    stats['MIN'] = (stats['SEC'] / 60).round(2)
    stats['REB'] = stats['OREB'] + stats['DREB']

    # TODO - map and sum
    stats['PTS'] = 0
    StatisticType.where{points_per > 0}.each do |statistic_type|
      stats['PTS'] += stats[statistic_type.code] * statistic_type.points_per
    end

    stats
  end

  # TODO - Create this automatically, once, at start
  def throw_percent_types
    ['FT','FG','FG3']
  end

  def throw_percent(stats, types=throw_percent_types, round='%.2f')
    tp = {}
    throw_percent_types.each do |type|
      made    = stats["#{type}M"].to_f
      attempt = stats["#{type}A"].to_f
      tp["#{type}_PCT"] = attempt > 0.0 ? (round % (made / attempt)) : nil
    end
    tp
  end
end