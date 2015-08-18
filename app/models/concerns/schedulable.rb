=begin

  Models that include this concern must have the following attributes
    - play_on:datetime
    - stop_on:datetime

  This concern provides methods to determine if that object should be
  played or not played.

=end

module Schedulable
  extend ActiveSupport::Concern

  included do
    scope :active, -> { where('play_on IS NULL OR play_on <= ?', Time.zone.now).where('stop_on IS NULL OR stop_on >= ?', Time.zone.now) }
  end

  def active?
    !upcoming? && !expired?
  end

  def upcoming?
    !(play_on.nil? || play_on <= Time.zone.now)
  end

  def expired?
    !(stop_on.nil? || stop_on >= Time.zone.now)
  end
end