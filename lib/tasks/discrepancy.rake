namespace :discrepancy do
  task :resolve, [] => [:environment] do |task, args|
      
  end

  task :report, [] => [:environment] do |task, args|
    Game.each do |game|
      game.team_in_games.each do |tig|
        pp tig.resolvable_statistics
      end
    end
  end
end