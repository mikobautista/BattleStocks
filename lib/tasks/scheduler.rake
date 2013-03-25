desc "This task is called by the Heroku scheduler add-on"

task :update_game_end => :environment do
  puts "Updating games..."
  Game.end_all_finished
  puts "done."
end
