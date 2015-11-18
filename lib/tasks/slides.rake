namespace :slides do
  desc 'Refresh all the screenshots of the slides'
  task take_screenshots: :environment do
    Slide.all.each(&:take_screenshot)
  end
end