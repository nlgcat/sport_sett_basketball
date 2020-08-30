class Game < Sequel::Model
  plugin :timestamps, update_on_create: true
  many_to_one :season
  one_to_many :team_in_games, limit: 2
  one_to_many :game_periods
  many_to_one :month_name
  many_to_one :dataset_splits
  one_through_one :stadium
  many_to_many :rotowire_entries

  include StatisticConcern

  # These are cached for efficiency.
  @team_period_scores_cache = {}

  def self.cached_team_period_scores game_id
    @team_period_scores_cache[game_id] ||= Game[game_id].team_period_scores
  end

  def basketball_reference_url
    "https://www.basketball-reference.com/boxscores/#{date_str}0#{team_codes[:home]}.html"
  end

  def self.date_from_segs season, month, day_i
    m = MonthName.find(name: month)
    year = m.id > 3 ? season.end_year : season.start_year
    Date.new(year, m.calander_month_int, day_i)
  end

  def basketball_reference_file scrape_type='basketball_reference', suffix='html'
    home_team_code = TeamName.rotowire_to_bref_code(team_codes[:home])
    file_key = "#{date_str}0#{home_team_code}"
    Rails.root.join('db', 'seed_files', scrape_type, "#{file_key}.#{suffix}")
  end

  def onmt_h tense=:PAST
    [id_h, date_h, location_h, teams_h].inject(&:merge)
  end

  def teams_h
    h = {}
    tigs = {
      home:     home_team_in_game,
      visiting: visiting_team_in_game,
    }
    tigs.each do |side, tig|
      side_key = side.to_s.upcase
      division_structure = tig.team_in_season.division_structure
      h["#{side_key}-TEAM"] = tig.team_name
      h["#{side_key}-TEAM-PLACE"] = tig.team_place_name
      h["#{side_key}-TEAM-CONFERENCE"] = division_structure.conference.name
      h["#{side_key}-TEAM-DIVISION"] = division_structure.division.name
    end
    h
  end

  def onmt_name
    "GAME-#{id}"
  end

  def omnt_entity_name
    "G-#{id}"
  end

  def dimensions
    {
      ENTITY: season.league_structure,
      EVENT:  season,
    }
  end

  def id_h
    {
      'GAME-ID' => id
    }
  end

  def location_h(tense=:PAST)
    h = tense == :PAST ? {'ATTENDANCE'    => stadium.capacity.round(-2)} : {}
    h.merge(stadium.onmt_h)
  end

  def all_statistics
    team_in_games.map(&:all_statistics).flatten
  end

  def sett_data
    data = []
    team_in_games.each do |tig|
      record_h = tig.record_h
      pitigs = tig.person_in_team_in_games
      padded_pitigs = pitigs + Array.new((15 - pitigs.size), false)
      padded_pitigs.each do |pitig|
        statistic_codes = %w(PTS MIN FGM FGA FG3M FG3A FTM FTA OREB DREB REB AST TO STL BLK PF)
        win_streak = record_h[:STREAK] =~ /W\d+/ ? record_h[:STREAK].tr('^0-9', '') .to_i : 0
        loss_streak = record_h[:STREAK] =~ /L\d+/ ? record_h[:STREAK].tr('^0-9', '') .to_i : 0
        game_data = { game_number: tig.game_number, wins: record_h[:WINS], losses: record_h[:LOSSES], win_streak: win_streak, loss_streak: loss_streak }
        if pitig
          statistics_h = pitig.statistics_h
          data << {
            statistics:   statistic_codes.map{ |code| [code, (statistics_h[code] ||= 0)] }.to_h,
            boolean:      {home: tig.home, starter: pitig.starter},
            names:        pitig.sett_names,
            game:         game_data,
            game_number:  tig.game_number
          }
        else
          data << {
            statistics:   statistic_codes.map{ |code| [code, 0] }.to_h,
            boolean:      {home: tig.home, starter: false},
            names:        [],
            game:         game_data,
            game_number:  tig.game_number
          }
        end
      end
    end
    data
  end

  def sett_names
    stadium.sett_names
  end

  def name
    "#{team_codes[:visiting]}@#{team_codes[:home]} on #{date} at #{stadium}"
  end

  def to_s
    "#{season} #{date}"
  end

  # TODO - combine the following two functions, they are very similar
  def team_in_game_periods
    tigs = {
      home:     home_team_in_game,
      visiting: visiting_team_in_game,
    }

    tigps = tigs.map{|side, tig| [side, tig.team_in_game_period_lookup] }.to_h
    pitigs = tigs.map{|side, tig| [side, tig.person_in_team_in_game_period_lookup] }.to_h

    return tigps[:home].merge(tigps[:visiting])
  end

  def person_in_team_in_game_periods
    tigs = {
      home:     home_team_in_game,
      visiting: visiting_team_in_game,
    }

    tigps = tigs.map{|side, tig| [side, tig.team_in_game_period_lookup] }.to_h
    pitigs = tigs.map{|side, tig| [side, tig.person_in_team_in_game_period_lookup] }.to_h

    return pitigs[:home].merge(pitigs[:visiting])
  end

  def people
    h = {}
    team_in_games.each do |tig|
      tig.person_in_games.each do |pig|
        person = pig.person
        h[person.id] = person
      end
    end
    h
  end

  def rotowire_box_score
    box = { 
      "FIRST_NAME" => {},
      "MIN" => {},
      "FGM" => {},
      "REB" => {},
      "FG3A" => {},
      "PLAYER_NAME" => {},
      "AST" => {},
      "FG3M" => {},
      "OREB" => {},
      "TO" => {},
      "START_POSITION" => {},
      "PF" => {},
      "PTS" => {},
      "FGA" => {},
      "STL" => {},
      "FTA" => {},
      "BLK" => {},
      "DREB" => {},
      "FTM" => {},
      "FT_PCT" => {},
      "FG_PCT" => {},
      "FG3_PCT" => {},
      "SECOND_NAME" => {},
      "TEAM_CITY" => {},
      "TEAM_NAME" => {},
    }

    y = 0
    [home_team_in_game, visiting_team_in_game].each do |tig|
      pitigs = tig.person_in_team_in_games
      (0..12).each do |x|
        if pitigs[x]
          pitig = pitigs[x]
          s_h = pitigs[x].statistics_h
          box['FIRST_NAME'][y] = pitig.first_name
          box['SECOND_NAME'][y] = pitig.last_name
          box['PLAYER_NAME'][y] = pitig.name
          box['START_POSITION'][y] = pitig.starter
          box['TEAM_CITY'][y] = tig.team_place_name
          box['TEAM_NAME'][y] = tig.team_name
          %w(FTA FTM FGA FGM FG3A FG3M PTS OREB DREB REB BLK STL AST PF TO MIN FT_PCT FG_PCT FG3_PCT).each do |stat|
            box[stat][y] = s_h[stat]
          end
        else
          box['FIRST_NAME'][y]  = 'NULL'
          box['SECOND_NAME'][y] = 'NULL'
          box['PLAYER_NAME'][y] = 'NULL'
          box['START_POSITION'][y] = 'NULL'
          box['TEAM_CITY'][y] = 'NULL'
          box['TEAM_NAME'][y] = 'NULL'
          %w(FTA FTM FGA FGM FG3A FG3M PTS OREB DREB REB BLK STL AST PF TO MIN FT_PCT FG_PCT FG3_PCT).each do |stat|
            box[stat][y] = 'NULL'
          end
        end
        y+=1
      end
    end

    box
  end

  # The original rowowire is ver difficult to read manually and presents problems for finding previous/next games.
  def to_rotowire_json(rwe)
    home_tig      = home_team_in_game
    visiting_tig  = visiting_team_in_game
    rwe_i = rwe.rw_line+1

    h = {
      "game_id" => id.to_s, # Note this is our Game ID, not the partially completed RW one
      "game"    => onmt_h,
      "home_team_next" => home_tig.game.onmt_h,
      "vis_team_next" => visiting_tig.onmt_h,
      "day"     => date_str('_', '%02d'),
      "summary" => rwe.summary,
      "home_name" => team_names[:home],
      "vis_name" =>  team_names[:visiting],
      "home_city" => team_place_names[:home],
      "vis_city" =>  team_place_names[:visiting],
      "home_line" => home_tig.rotowire_json_line(),
      "vis_line" => visiting_tig.rotowire_json_line(),
      "box_score" => rotowire_box_score,
    }
  end

  def date_h year_format='%04d'
    year  = format(year_format, season.start_year + month_name.year_offset)
    month = format('%02d', month_name.calander_month_int)
    day   = format('%02d', day_of_month)
    {
      'YEAR'  => year,
      'MONTH' => month_name.name,
      'DAY'   => day,
      'DAYNAME' => Date.new(year.to_i, month.to_i, day.to_i).strftime("%A"),
    }
  end

  def date_str delimiter='', year_format='%04d'
    year  = format(year_format, season.start_year + month_name.year_offset)
    month = format('%02d', month_name.calander_month_int)
    day   = format('%02d', day_of_month)
    "#{year}#{delimiter}#{month}#{delimiter}#{day}"
  end

  def teams_in_game
    {
      home: home_team_in_game,
      visiting: visiting_team_in_game,
    }
  end

  def team_period_scores
    h = {}
    teams_in_game.each do |side, tig|
      tig.team_in_game_periods.each do |tigp|
        period = tigp.game_period.value
        h[period] ||= {}
        h[period][tig.code] = tigp.statistics_h['PTS']
      end
    end
    h
  end

  def home_team_in_game
    team_in_games.select{|tig| tig.home }.first
  end

  def visiting_team_in_game
    team_in_games.select{|tig| !tig.home}.first
  end

  def home_team
    home_team_in_game.team
  end

  def visiting_team
    visiting_team_in_game.team
  end

  def team_in_game_from_code code
    h = {
      home_team.code => home_team_in_game,
      visiting_team.code => visiting_team_in_game,
    }
    h[code]
  end

  def basketball_ref_team_names
    t = team_names
    l = team_place_names
    home_place = l[:home] == 'Los Angeles' ? 'LA' : l[:home]
    visiting_place = l[:visiting] == 'Los Angeles' ? 'LA' : l[:visiting]
    {
      home:     home_place      == 'LA' ? "#{home_place} #{t[:home]}"         : home_place,
      visiting: visiting_place  == 'LA' ? "#{visiting_place} #{t[:visiting]}" : visiting_place,
    }
  end

  def derby?
    Set.new(team_place_names.values).size < 2
  end

  def team_codes
    {
      home:     home_team.code,
      visiting: visiting_team.code,
    }
  end

  def team_place_names
    {
      home:     home_team.place_name,
      visiting: visiting_team.place_name,
    }
  end

  def team_names
    {
      home:     home_team.team_name.name,
      visiting: visiting_team.team_name.name,
    }
  end

  def team_points
    {
      home:     home_team_in_game.points,
      visiting: visiting_team_in_game.points,
    }
  end

  def game_periods_lookup
    game_periods.map{|v| [v.value, v]}.to_h
  end
end
