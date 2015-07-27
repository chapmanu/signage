class AddReferenceToSlides < ActiveRecord::Migration
  def change
    add_reference :slides, :device, index: true, foreign_key: true
  end
end
