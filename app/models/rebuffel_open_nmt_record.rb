class RebuffelOpenNMTRecord
  attr_accessor :entities
  attr_accessor :texts
  attr_accessor :game

  # Custom class to make Rebuffel style records, this is meant just as a quick one-off script
  def initialize game, max_size=24
    @game         = game

    person_entities = []
    team_entities = []

    game.team_in_games.each do |tig|
      tig.person_in_team_in_games.each do |pitig|
        # Create the player entities
        
        # This is slightly different as we do not have start positions from Rotowire
        entity = [['<ent>','<ent>'],[(pitig.starter ? 'yes' : 'no'), 'STARTER']]

        pitig_h = pitig.statistics_h

        %w(MIN PTS FGM FGA FG_PCT FG3M FG3A FG3_PCT FTM FTA FT_PCT OREB DREB REB AST TO STL BLK PF).each do |code|
          stat = pitig_h.has_key?(code) ? pitig_h[code] : (code =~ /_PCT/ ? 'N/A' : '0')
          entity << [stat, code]
        end

        entity << [pitig.first_name,  'FIRST_NAME']
        entity << [pitig.last_name, 'LAST_NAME']
        entity << [(tig.home ? 'yes' : 'no'), 'IS_HOME']

        while entity.size < max_size
          entity << ['<blank>','<blank>']
        end

        raise "too many elements (#{entity.size}) in entity" unless entity.size <= max_size

        person_entities << entity.map{|x| x.join('￨').gsub(/\s/,'_') }.join(' ')
      end

      # Create the team entities
      entity = [['<ent>','<ent>']]
      (1..4).each do |q|
        entity << [tig.team_in_game_periods.find{|tigp| tigp.game_period.value.to_s == "#{q}" }.statistics_h['PTS'], "TEAM-PTS-QTR#{q}"]
      end

      tig_h = tig.statistics_h

      %w(PTS FGM FGA FG_PCT FG3M FG3A FG3_PCT FTM FTA FT_PCT REB AST TOV).each do |code|
        stat = tig_h.has_key?(code) ? tig_h[code] : (code =~ /_PCT/ ? 'N/A' : '0')
        entity << [stat, "TEAM-#{code}"]
      end

      record_h = tig.record_h

      entity << [record_h[:WINS], 'TEAM_WINS']
      entity << [record_h[:LOSSES], 'TEAM_LOSSES']
      entity << [tig.team_name, 'TEAM_NAME']
      entity << [tig.team_place_name, 'TEAM_PLACE'] # We use place because Golden State is not a city
      entity << [(tig.home ? 'yes' : 'no'), 'IS_HOME']

      while entity.size < max_size
        entity << ['<blank>','<blank>']
      end

      raise "too many elements (#{entity.size}) in entity" unless entity.size <= max_size

      team_entities << entity.map{|x| x.join('￨').gsub(/\s/,'_') }.join(' ')
    end

    @entities = person_entities + team_entities
  end

  def values
    @entities.map{|ent| ent.split(' ').map{|a| a.split('￨')[0] } }.flatten.uniq
  end

  def to_s
    @entities.join(" ")
  end
end