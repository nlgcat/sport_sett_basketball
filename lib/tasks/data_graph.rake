namespace :data_graph do
  # Splits strings by entity for easier reading by humans
  task :gen, [:game_id] => [:environment] do |task, args|
    game = Game[:game_id]
    dimensions = []

    # Game
    # - Team A
    # - Team B
    # - Score
    # - Stadium
    # - Location(s)
    # - The day of the week

    game_dimension = []
    teams_in_game.each do |_k, tig|
      team_n = tig.team_name
      place_n = tig.team_place_name
      game_dimension << {
        values: [team_n, place_n, "#{place_n} #{team_n}"], # TODO - Nicknames like 76ers/Sixers
        entity_types: ['ORG', 'GPE'],
        minimum: 1,
        maximum: 1
      }
      game_dimension[:values] << 'Sixers' if team_n == '76ers'
    end

    team_points = game.team_points
    score = [team_points[:home], team_points[:visiting]].sort

    game_dimension << {
      values: [score.join('-'), score.join(' to ')],
      entity_types: ['CARDINAL_COMPARISON'],
      minimum: 1,
      maximum: 1
    }

    game_dimension << {
      values: [game.place.all_parents],
      entity_types: ['GPE'],
      minimum: 0,
      maximum: nil
    }

    game_dimension << {
      values: game.stadium.name,
      entity_types: ['FAC', 'GPE', 'ORG'],
      minimum: 1,
      maximum: 1
    }

    game_dimension << {
      values: [game.date_h['DAYNAME']],
      entity_types: 'DATE',
      minimum: 1,
      maximum: 1
    }

    dimensions << game_dimension

    pp dimensions
  end
end