class AddSponsorsToSlides < ActiveRecord::Migration

  def up

  	Slide.find_each do |slide|
  		name = slide.organizer
  		icon_path = "organizers/icon-#{SlidesHelper::ORGANIZER_ICONS[name] || 'chapman'}.svg"
  		sponsor = Sponsor.find_or_create_by(name: name, icon: icon_path)
  		slide.sponsor = sponsor
      slide.save!
  	end
  end

  def down
  	Slide.find_each do |slide|
  		slide.sponsor = nil
  	end
  	
  	Sponsor.delete_all
  end
end
