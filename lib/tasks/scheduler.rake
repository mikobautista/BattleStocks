desc "This task is called by the Heroku scheduler add-on"

task :update_game_end => :environment do
  puts "Updating games..."
  # end all games
  Game.end_if_finished
  puts "done."
end
