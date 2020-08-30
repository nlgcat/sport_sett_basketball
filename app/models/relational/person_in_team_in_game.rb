class PersonInTeamInGame < Sequel::Model
  plugin :timestamps, update_on_create: true
  many_to_many :positions
  many_to_one :person_in_team_in_season
  many_to_one :team_in_game
  one_to_many :person_in_team_in_game_periods
  many_to_many :statistics
  many_to_many :discrepancies

  include StatisticConcern

  def all_statistics
    statistics
  end

  def omnt_entity_name
    person.url_seg
  end

  def dimensions
    {
      ENTITY: person,
      EVENT:  team_in_game,
    }
  end

  def onmt_h tense=:PAST
    [person.onmt_h, starter_h, statistics_h].inject(&:merge)
  end

  def onmt_name
    puts person.name
  end

  def starter_h
    { STARTER: "#{starter}" }
  end

  def all_play_statistics
    person_in_team_in_game_periods.map{|pitigp| pitigp.all_play_statistics }.flatten
  end

  def all_person_in_team_in_game_period_statistics
    person_in_team_in_game_periods.map{|pitigp| pitigp.all_statistics }.flatten
  end

  # TODO - consolodate these with other classes
  def find_discrepancies
    StatisticType.each do |statistic_type|
      next if ['TF', 'DF', 'VIO', 'REB', 'PTS', 'MIN', 'SEC', '+/-'].include? statistic_type.code
      stats = {
        game:   all_statistics.select{|s| s.statistic_type_id == statistic_type.id },
        period: all_person_in_team_in_game_period_statistics.select{|s| s.statistic_type_id == statistic_type.id },
        play:   all_play_statistics.select{|s| s.statistic_type_id == statistic_type.id },
      }

      raise "Too many statistics for game" if stats[:game].size > 1
      totals = stats.map{|k,v| [k,v.map(&:quantity).sum] }.to_h
      if totals.values.uniq.size > 1
        if totals[:period] == totals[:play]


          # TODO - Cleaner way to handle this
          # - This should resolve the cases where there is no statistic but should be one
          if stats[:game].size ==  0
            s = Statistic.create(quantity: 0, statistic_type_id: statistic_type.id)
            stats[:game] = [s]
            self.add_statistic s
          end


          adjustment  = DiscrepancyAdjustment.create(quantity: totals[:game], quantity_should_be: totals[:period])
          discrepancy = PersonInTeamInGameDiscrepancy.create
          discrepancy.statistic  = stats[:game].first
          discrepancy.discrepancy_adjustment = adjustment
        else
          if totals[:game] == totals[:play]
            discrepancy = PersonInTeamInGamePeriodDiscrepancy.create
          elsif totals[:game] == totals[:period]
            discrepancy = PlayStatisticDiscrepancy.create
          else
            discrepancy = Discrepancy.create
            
          end
          pp stats.map(&:to_s)
          puts " #{statistic_type.code} #{totals[:game]} == #{totals[:period]} == #{totals[:play]}"
          puts "---\n"
        end
        discrepancy.person_in_team_in_game = self
        discrepancy.team_in_game = self.team_in_game
      end
    end
  end

  def person_in_team_in_game_period_lookup key=:value
    person_in_team_in_game_periods.map{|pitigp| [pitigp.game_period.send(key), pitigp] }.to_h
  end

  def sett_names
    arr = [name, first_name, last_name] + team_in_game.sett_names
    (arr.map{|n| I18n.transliterate n } + arr.map{|n| (I18n.transliterate n).gsub(/[^A-Za-z]/, ' ') }).uniq
  end

  def person
    person_in_team_in_season.person
  end

  def name
    Person.format_name person.name
  end

  def first_name
    Person.format_name person.first_name
  end

  def last_name
    Person.format_name person.last_name
  end

  def team_name
    team_in_game.team_name
  end

  def team_place_name
    team_in_game.team_place_name
  end
end
