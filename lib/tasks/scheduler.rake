desc "This task is called by the Heroku scheduler add-on"
task :send_commits => :environment do
  puts "Sending commit emails..."
  Notifications.send
  puts "done."
end
