namespace :nlg do

  # Splits strings by entity for easier reading by humans
  task :gen, [:game_id] => [:environment] do |task, args|
    game = Game[args[:game_id]]

    strs = []

    # Where was the game played
    strs += MessageThisGame.new(game).generate

    # What was the difference in the game
    strs += MessageDifferenceInGame.new(game).generate


    pp strs
  end
end