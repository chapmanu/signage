class Faculty < ActiveRecord::Base
  # Currently Faculty records are not modified anywhere within the application beyond the sync job
  default_scope { order(:last_name) }

  scope :in_building, -> (name) { where('building_name = ? OR building_name_2 = ?', name, name) }

  def self.all_building_names
    pluck(:building_name, :building_name_2).flatten.uniq.reject(&:blank?).sort
  end
end
