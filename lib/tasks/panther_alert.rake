namespace :panther_alert do

  desc 'Check the server for panther alerts'
  task check: :environment do
    updates = CheckPantherAlertJob.perform_now
    puts updates unless updates.values.all?(&:nil?)
  end
end
