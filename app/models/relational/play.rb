class Play < Sequel::Model
  plugin :timestamps, update_on_create: true

  one_to_many :play_statistics
  many_to_one :game_period
  one_through_one :team_in_game # Possession

  def self.format_play_text game, cell, generic_player = true
    arr = []
    cell.children.each do |element|
      x = element.text
      if element.node_name == 'a'
        p_t = element.attributes['href'] ? element.attributes['href'].value : element.text
        x = (generic_player ? 'PLAYER' : "{#{p_t}}")
      end
      arr << x
    end
    txt = arr.join
    # TODO - work out how to handle nbsp properly, the " " is a nbsp char
    txt == " " ? '' : txt.strip
  end

  def self.format_score_increment str
    return 0 if str.blank?
    return str[/\d+/] if str =~ /\+\d*/
    return -(str[/\d+/].to_i) if str =~ /\-\d*/
    raise "Invalid score increment #{str}"
  end

  def self.split_left_right_paranthesis_text str, side
    q = str[/\((.*?)\)/]
    str_f = str
    if side == :left
      str_f = (q == nil ? str : str.sub(q,''))
    elsif side == :right
      str_f = (q ? q : '').gsub(/[\(\)]/,'')
    end
    str_f.strip
  end

  # PLAYER misses X-pt hook shot from X ft (block by PLAYER)
  def self.get_pbp_simple_args str, side, keys={}, code='N/A', r=/\sby\s/
    str_f = self.split_left_right_paranthesis_text(str, side)
    h = str_f.split(r).each_with_index.map { |v,i| [keys[side][i],v.strip] }.to_h
    h[:player_or_team] ? h.to_h.merge({codes: [code]}) : h
  end

  # FG
  # PLAYER [makes|misses] X-pt SHOT_TYPE [at rim|from Y ft] ([assist|block] by PLAYER)
  def self.get_pbp_fg str, side, keys={}, r=/\sby\s/
    success = str =~ /makes/ ? true : false
    return self.get_pbp_simple_args(str, side, keys, (success ? 'AST' : 'BLK'), r) if side == :right
    str_f = self.split_left_right_paranthesis_text(str, side)
    arr = str_f.split(/\smakes\s|\smisses\s|\sat\s|\sfrom\s/)
    
    points = arr[1][/\d\-pt\s/].strip[/\d/]
    codes = ['FGA']
    codes << "FGM" if success
    if points == '3'
      codes << "FG3A" 
      codes << "FG3M" if success
    end
    {
      player_or_team: arr[0].strip,
      success:        success,
      shot_points:    points,
      type:           arr[1].sub(/\d\-pt\s/, '').strip,
      shot_distance:  arr[2].strip,
      codes:          codes,
    }
  end

  # FT
  # PLAYER [makes|misses] FT_TYPE X of Y
  def self.get_pbp_ft str, side, keys={}, r=/\sby\s/
    return self.get_pbp_simple_args(str, side, keys, r) if side == :right
    str_f = self.split_left_right_paranthesis_text(str, side)
    arr = str_f.split(/\smakes\s|\smisses\s/)

    player_or_team = arr[0].strip

    shot_type = arr[1] ? arr[1].gsub(/\d\sof\s\d/, '').strip : ''
    x_y_str   = arr[1] ? arr[1].gsub(shot_type, '').strip : ''
    x_y = x_y_str.scan(/\d+/)

    x = 1
    y = 1

    x = x_y[0].strip if x_y.size > 0
    y = x_y[1].strip if x_y.size > 1

    # puts "#{player_or_team} FT: #{shot_type} #{x} of #{y}"
    success = str_f =~ /makes/ ? true : false
    codes = ['FTA']
    codes << 'FTM' if success
    
    {
      player_or_team: player_or_team,
      success:        success,
      type:           shot_type,
      x:              x,
      y:              y,
      codes:          codes,
    }
  end

  def self.create_from_text game, game_period, cells, verbose=false
    tigps = game.team_in_game_periods
    pitigps = game.person_in_team_in_game_periods

    possessing_sides = {
      1 => game.visiting_team_in_game,
      5 => game.home_team_in_game,
    }
    
    possessing_sides.each do |cell_id, tig|
      str = self.format_play_text(game, cells[cell_id])
      vars = self.format_play_text(game, cells[cell_id], false).scan(/[^{\}]+(?=})/)

      result = {left: {}, right: {}}
      next if str.gsub(/\s/,'') == ''
      # Fouls
      if str =~ /foul/
        if str =~ /3 sec tech/ || str =~ /[Tt]echnical foul by/
          # TODO - This is a team foul, even if someone was called for it.
        elsif str =~ /foul by/ || str =~ /[Ff]lagrant/
          # See M.G. comments on fouled out (F, TF, FF)
          # Probably add these as reasons
          keys = {left: [:type, :player_or_team], right: [:type, :player_or_team]}
          [:left, :right].each{ |l_r| result[l_r] = self.get_pbp_simple_args(str, l_r, keys, (l_r == :right ? 'DF' : 'PF')) }
        end
      end

      # Rebounds
      if str =~ /rebound/
        code = str =~/[Oo]ffensive/ ? 'OREB' : 'DREB'
        keys = {left: [:type, :player_or_team], right: [:type, :player_or_team]}
        [:left, :right].each{ |l_r| result[l_r] = self.get_pbp_simple_args(str, l_r, keys, code) }
      end

      # Timeouts
      if str =~ /[tT]imeout/
        if str =~ /[fF]ull timeout/
          result[:left] = {player_or_team: str.sub(/[fF]ull timeout/, ''), type: 'full timeout', codes: ['TTO']}
        else
          result[:left] = {player_or_team: str.sub(/[tT]imeout/, ''), type: 'timeout', codes: ['OTO']}
        end
      end
     

      # Subs / Ejections
      if str =~ /ejected from game/
        result[:left] = {player_or_team: str.sub(/\sejected from game/, ''), type: 'ejected from game', codes: ['EJE']}
      elsif str =~ /enters the game for/
        keys = {left: [:type, :player_or_team]}
        result[:left] = self.get_pbp_simple_args(str, :left, keys, 'SUB', /\sfor\s/)
      end

      # Turnovers / Steals
      if str =~ /Turnover/
        keys = {left: [:type, :player_or_team], right: [:type, :type, :player_or_team]}
        [:left, :right].each{|l_r| result[l_r] = self.get_pbp_simple_args(str, l_r, keys, (l_r == :left ? 'TOV' : 'STL'), /;\s|\sby\s/) }
      end

      # Violations
      if str =~ /Violation/
        keys = {left: [:type, :player_or_team], right: []}
        result[:left] = self.get_pbp_simple_args(str, :left, keys, 'VIO')
      end

      
      if str =~ /makes|misses/
        if str =~ /free throw/
          # FT
          # PLAYER [makes|misses] FT_TYPE X of Y
          keys = {left: {}, right: [:type, :player_or_team]}
          [:left, :right].each{|l_r| result[l_r] = self.get_pbp_ft(str, l_r, keys) }
        elsif str =~ /\sfrom\s|\sat\s/
          # FG
          # PLAYER [makes|misses] X-pt SHOT_TYPE [at rim|from Y ft] ([assist|block] by PLAYER)
          keys = {left: {}, right: [:type, :player_or_team]}
          [:left, :right].each{|l_r| result[l_r] = self.get_pbp_fg(str, l_r, keys) }
        else
          raise "Invalid make/miss #{str}"
        end
      end


      scores = cells[3].text.split('-')
      t_arr = cells[0].text.split(':').map{|x| x.to_f}

      time_seconds = (t_arr[0] * 60) + t_arr[1]

      play = Play.create(
        game_period_id: game_period.id,
        time_seconds: time_seconds,
        home_score: format_score_increment(cells[4].text),
        home_cumulative_score: scores[1],
        visiting_score: format_score_increment(cells[2].text),
        visiting_cumulative_score: scores[0],
      )

      # Team with possession
      play.team_in_game = tig 

      orig_vars = vars.clone

      [:left, :right].each do |l_r|
        data = result[l_r]
        
        next if data.size == 0
        next unless data[:codes]
        unless (['SUB', 'EJE', 'TTO', 'OTO'] & data[:codes]).empty?
          # puts "Skipping NOT IMP: #{data}"
          next
        end

        var = vars.shift

        data[:codes].each do |code|
          s = Statistic.create(quantity: 1, statistic_type_id: StatisticType.id_from_code(code))
          ps = PlayStatistic.create(play_id: play.id, statistic_id: s.id)
          raise "gah" if s == nil || ps == nil
          if data[:player_or_team] == 'Team'
            # puts "Skipping TEAM STAT #{data}"
            # TODO - Need the side here
            # tigps[side][play_h[:period]].add_play_statistic(ps)
          else
            begin
              pitigp = pitigps[var][game_period.value]
              pitigp.add_play_statistic(ps)
              puts "  #{pitigp.name} awarded 1 #{code}" if verbose
            rescue Exception => e
              puts "\n\n+++ERROR creating play_from_text #{var} #{game_period.value}"
              puts str
              pp e
              pp pitigps
              pp pitigp
              pp ps
              pp data
              puts game.basketball_reference_url
              puts "+++\n\n"
            end
          end
        end
      end
    end
  end
end
