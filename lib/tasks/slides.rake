namespace :slides do
  desc 'Refresh all the screenshots of the slides'
  task take_screenshots: :environment do
    Slide.all.each(&:take_screenshot)
  end

  task 'Reset counters'
  task fix_counts: :environment do
    Slide.all.ids.each do |id|
      Slide.reset_counters(id, :signs)
    end
  end
end