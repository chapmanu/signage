namespace :faculty do
  desc "Fetch faculty data and save it"
  task sync: :environment do
    FetchFacultyDataJob.perform_now
  end
end